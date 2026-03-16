import Foundation

@MainActor
final class AccountSurfaceStore: ObservableObject {
    @Published var subscriptionState: LocalSubscriptionSnapshot
    @Published var notificationPermission: NotificationPermissionSnapshot
    @Published var accountNotice: String?
    @Published var exportPreview: String?

    private let repository: SwiftDataRepository
    private let analyticsClient: AnalyticsClient
    private let remoteConfigClient: RemoteConfigClient
    private let notificationManager: NotificationManaging
    private let glanceSurfaceStore: GlanceSurfaceStore
    private let liveActivityCoordinator: LiveActivityCoordinator
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        repository: SwiftDataRepository,
        analyticsClient: AnalyticsClient,
        remoteConfigClient: RemoteConfigClient,
        notificationManager: NotificationManaging,
        glanceSurfaceStore: GlanceSurfaceStore,
        liveActivityCoordinator: LiveActivityCoordinator
    ) {
        self.repository = repository
        self.analyticsClient = analyticsClient
        self.remoteConfigClient = remoteConfigClient
        self.notificationManager = notificationManager
        self.glanceSurfaceStore = glanceSurfaceStore
        self.liveActivityCoordinator = liveActivityCoordinator

        if let record = try? repository.fetchSubscriptionState(),
           let snapshot = try? decoder.decode(LocalSubscriptionSnapshot.self, from: record.payload) {
            subscriptionState = snapshot
        } else {
            subscriptionState = .free
        }

        if let raw = UserDefaults.standard.string(forKey: Self.notificationPermissionKey),
           let permission = NotificationPermissionSnapshot(rawValue: raw) {
            notificationPermission = permission
        } else {
            notificationPermission = .notDetermined
        }
    }

    var isPremium: Bool {
        subscriptionState.hasPremiumBreadth
    }

    var supportsAdvancedWidgets: Bool {
        isPremium && featureFlag(.advancedWidgetsEnabled)
    }

    var supportsLiveActivities: Bool {
        isPremium && featureFlag(.liveActivitiesEnabled)
    }

    var shouldShowNotificationEducation: Bool {
        notificationPermission == .notDetermined
    }

    func syncFromCoreLoop(_ coreLoop: FirstPlayableStore) {
        let reminderTime = coreLoop.activeVows
            .compactMap(\.schedule.reminderLocalTime)
            .first ?? "08:00"
        let hour = Int(reminderTime.split(separator: ":").first ?? "8") ?? 8
        let minute = Int(reminderTime.split(separator: ":").dropFirst().first ?? "0") ?? 0
        let topChain = coreLoop.activeVows.map(\.chainLength).max() ?? 0

        let payload = GlanceSurfacePayload(
            generatedAt: ISO8601DateFormatter().string(from: .now),
            today: TodayGlanceSnapshot(
                dayTitle: "Day \(coreLoop.chapterState.currentDay)",
                chapterTitle: coreLoop.chapterState.title,
                districtStageTitle: coreLoop.districtState.stageTitle,
                activeVowCount: coreLoop.activeVows.count,
                completedVowCount: coreLoop.activeVows.filter(\.isCompleteToday).count,
                topChainLength: topChain,
                reminderHour: hour,
                reminderMinute: minute,
                witnessPrompt: coreLoop.chapterState.tomorrowPrompt
            ),
            liveActivity: LiveActivityGlanceSnapshot(
                isEnabled: supportsLiveActivities,
                chapterTitle: coreLoop.chapterState.title,
                districtStageTitle: coreLoop.districtState.stageTitle,
                progressPercent: Int(coreLoop.chapterState.progressPercent * 100),
                activeVowCount: coreLoop.activeVows.count
            ),
            subscription: subscriptionState,
            notificationPermission: notificationPermission
        )

        glanceSurfaceStore.save(payload)

        Task {
            await liveActivityCoordinator.sync(with: payload)
            if notificationPermission == .authorized {
                await notificationManager.scheduleStarterArcNotifications(using: payload)
            }
        }
    }

    func startTrial(using coreLoop: FirstPlayableStore) {
        track(.trialStarted, surface: "paywall", properties: ["tier": SubscriptionTierSnapshot.trial.rawValue])
        subscriptionState = LocalSubscriptionSnapshot(
            tier: .trial,
            billingState: .active,
            trialEligible: false,
            expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(7 * 86_400)),
            restoreTier: .trial
        )
        persistSubscription()
        coreLoop.dismissSoftPaywall()
        accountNotice = "Your 7-day free trial is active."
        syncFromCoreLoop(coreLoop)
    }

    func purchase(tier: SubscriptionTierSnapshot, using coreLoop: FirstPlayableStore) {
        track(.purchaseStarted, surface: "paywall", properties: ["tier": tier.rawValue])
        subscriptionState = LocalSubscriptionSnapshot(
            tier: tier,
            billingState: .active,
            trialEligible: false,
            expiresAt: nil,
            restoreTier: tier
        )
        persistSubscription()
        coreLoop.dismissSoftPaywall()
        accountNotice = tier == .premiumAnnual ? "Annual premium is active." : "Monthly premium is active."
        track(.purchaseCompleted, surface: "paywall", properties: ["tier": tier.rawValue])
        syncFromCoreLoop(coreLoop)
    }

    func restorePurchases(using coreLoop: FirstPlayableStore) {
        guard let restoreTier = subscriptionState.restoreTier else {
            accountNotice = "No previous purchase was found to restore."
            return
        }

        subscriptionState.tier = restoreTier
        subscriptionState.billingState = .active
        if restoreTier == .trial {
            subscriptionState.expiresAt = ISO8601DateFormatter().string(from: Date().addingTimeInterval(7 * 86_400))
        } else {
            subscriptionState.expiresAt = nil
        }
        persistSubscription()
        accountNotice = "Your purchase was restored."
        track(.subscriptionRestored, surface: "settings", properties: ["tier": restoreTier.rawValue])
        syncFromCoreLoop(coreLoop)
    }

    func downgradeToFree(using coreLoop: FirstPlayableStore) {
        if subscriptionState.tier != .free {
            subscriptionState.restoreTier = subscriptionState.tier
        }
        subscriptionState.tier = .free
        subscriptionState.billingState = .expired
        subscriptionState.trialEligible = false
        subscriptionState.expiresAt = ISO8601DateFormatter().string(from: .now)
        persistSubscription()
        accountNotice = "Premium breadth has cooled back to the free path."
        track(.subscriptionCanceled, surface: "settings", properties: ["restore_tier": subscriptionState.restoreTier?.rawValue ?? "none"])
        syncFromCoreLoop(coreLoop)
    }

    func linkGuestAccount(using coreLoop: FirstPlayableStore, identityToken: String) {
        coreLoop.linkCurrentGuestAccount(identityToken: identityToken)
        accountNotice = "Your guest progress is now linked to Apple."
    }

    func prepareExport(using coreLoop: FirstPlayableStore) {
        exportPreview = """
        Auth: \(coreLoop.authMode.capitalized)
        Starter arc: \(coreLoop.completionDayCount)/7 days
        Active vows: \(coreLoop.activeVows.count)
        Subscription: \(subscriptionState.tier.rawValue)
        """
        accountNotice = "A local export preview is ready."
    }

    func deleteAccount(using coreLoop: FirstPlayableStore) {
        coreLoop.resetForDeletedAccount()
        subscriptionState = .free
        persistSubscription()
        notificationPermission = .notDetermined
        persistNotificationPermission()
        exportPreview = nil
        accountNotice = "The local account state was cleared. You can begin again."
        syncFromCoreLoop(coreLoop)
    }

    func requestNotifications(using coreLoop: FirstPlayableStore) {
        track(.notificationPromptViewed, surface: "today", properties: ["placement": "return_surfaces"])
        Task {
            let result = await notificationManager.requestAuthorization()
            await MainActor.run {
                notificationPermission = result
                persistNotificationPermission()
                track(.notificationPermissionResult, surface: "today", properties: ["result": result.rawValue])
                if result == .authorized {
                    accountNotice = "Notifications are on. Aevora will keep your cadence visible."
                } else {
                    accountNotice = "Notifications stayed off. The free path still works fully in-app."
                }
                syncFromCoreLoop(coreLoop)
            }
        }
    }

    private func persistSubscription() {
        if let payload = try? encoder.encode(subscriptionState) {
            try? repository.saveSubscriptionState(payload: payload, tier: subscriptionState.tier.rawValue)
        }
    }

    private func persistNotificationPermission() {
        UserDefaults.standard.set(notificationPermission.rawValue, forKey: Self.notificationPermissionKey)
    }

    private func featureFlag(_ flag: FeatureFlag) -> Bool {
        (try? remoteConfigClient.featureFlag(flag)) ?? false
    }

    private func track(_ eventName: AnalyticsEventName, surface: String, properties: [String: String]) {
        Task {
            try? await analyticsClient.track(AnalyticsEvent(name: eventName, surface: surface, properties: properties))
        }
    }

    private static let notificationPermissionKey = "account.notification.permission.v1"
}
