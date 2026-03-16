import Foundation

@MainActor
final class AccountSurfaceStore: ObservableObject {
    @Published var subscriptionState: LocalSubscriptionSnapshot
    @Published var notificationPermission: NotificationPermissionSnapshot
    @Published var healthKitPermission: HealthKitPermissionSnapshot
    @Published var accountNotice: String?
    @Published var exportPreview: String?
    @Published var lastNotificationPlan: NotificationPlan?
    @Published var lastHealthKitSyncAt: Date?

    private let repository: SwiftDataRepository
    private let analyticsClient: AnalyticsClient
    private let remoteConfigClient: RemoteConfigClient
    private let notificationManager: NotificationManaging
    private let healthKitManager: HealthKitManaging
    private let glanceSurfaceStore: GlanceSurfaceStore
    private let liveActivityCoordinator: LiveActivityCoordinator
    private let automationSurfaceStore: AutomationSurfaceStore
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let isoFormatter = ISO8601DateFormatter()

    init(
        repository: SwiftDataRepository,
        analyticsClient: AnalyticsClient,
        remoteConfigClient: RemoteConfigClient,
        notificationManager: NotificationManaging,
        healthKitManager: HealthKitManaging,
        glanceSurfaceStore: GlanceSurfaceStore,
        liveActivityCoordinator: LiveActivityCoordinator,
        automationSurfaceStore: AutomationSurfaceStore = AutomationSurfaceStore()
    ) {
        self.repository = repository
        self.analyticsClient = analyticsClient
        self.remoteConfigClient = remoteConfigClient
        self.notificationManager = notificationManager
        self.healthKitManager = healthKitManager
        self.glanceSurfaceStore = glanceSurfaceStore
        self.liveActivityCoordinator = liveActivityCoordinator
        self.automationSurfaceStore = automationSurfaceStore

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

        if let raw = UserDefaults.standard.string(forKey: Self.healthKitPermissionKey),
           let permission = HealthKitPermissionSnapshot(rawValue: raw) {
            healthKitPermission = permission
        } else {
            healthKitPermission = .notDetermined
        }

        if let raw = UserDefaults.standard.string(forKey: Self.lastHealthKitSyncKey),
           let date = isoFormatter.date(from: raw) {
            lastHealthKitSyncAt = date
        } else {
            lastHealthKitSyncAt = nil
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

    var canUseVerifiedInputs: Bool {
        isPremium && featureFlag(.healthKitVerificationEnabled)
    }

    var shouldShowNotificationEducation: Bool {
        notificationPermission == .notDetermined
    }

    var shouldShowHealthKitEducation: Bool {
        canUseVerifiedInputs && healthKitPermission == .notDetermined
    }

    func syncFromCoreLoop(_ coreLoop: FirstPlayableStore) {
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }

            await self.refreshNotificationPermission()

            let payload = self.buildGlancePayload(for: coreLoop)
            let notificationPlan = self.buildNotificationPlan(for: coreLoop)

            self.lastNotificationPlan = notificationPlan
            self.glanceSurfaceStore.save(payload)
            self.automationSurfaceStore.save(from: coreLoop)

            await self.liveActivityCoordinator.sync(with: payload)
            if self.notificationPermission == .authorized {
                await self.notificationManager.scheduleNotifications(using: notificationPlan)
            }
        }
    }

    func startTrial(using coreLoop: FirstPlayableStore) {
        track(.trialStarted, surface: "paywall", properties: ["tier": SubscriptionTierSnapshot.trial.rawValue])
        subscriptionState = LocalSubscriptionSnapshot(
            tier: .trial,
            billingState: .active,
            trialEligible: false,
            expiresAt: isoFormatter.string(from: Date().addingTimeInterval(7 * 86_400)),
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
            subscriptionState.expiresAt = isoFormatter.string(from: Date().addingTimeInterval(7 * 86_400))
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
        subscriptionState.expiresAt = isoFormatter.string(from: .now)
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
        HealthKit: \(healthKitPermission.rawValue)
        """
        accountNotice = "A local export preview is ready."
    }

    func deleteAccount(using coreLoop: FirstPlayableStore) {
        coreLoop.resetForDeletedAccount()
        subscriptionState = .free
        persistSubscription()
        notificationPermission = .notDetermined
        persistNotificationPermission()
        healthKitPermission = .notDetermined
        persistHealthKitPermission()
        lastHealthKitSyncAt = nil
        persistLastHealthKitSync()
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

    func connectHealthKit(using coreLoop: FirstPlayableStore) {
        guard canUseVerifiedInputs else {
            accountNotice = "HealthKit verification opens with premium breadth."
            return
        }

        track(.healthkitPromptViewed, surface: "settings", properties: ["source": "integrations"])
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }

            let result = await healthKitManager.requestAuthorization(for: HealthKitDomain.allCases)
            self.healthKitPermission = result
            self.persistHealthKitPermission()
            self.track(.healthkitPermissionResult, surface: "settings", properties: ["result": result.rawValue])

            if result == .authorized {
                self.accountNotice = "HealthKit is connected for narrow verified inputs."
                await self.refreshVerifiedInputsNow(using: coreLoop)
            } else if result == .unavailable {
                self.accountNotice = "HealthKit is unavailable on this device."
            } else {
                self.accountNotice = "HealthKit stayed off. Manual logging is still fully available."
            }
        }
    }

    func refreshVerifiedInputs(using coreLoop: FirstPlayableStore) {
        guard canUseVerifiedInputs else {
            return
        }

        Task { @MainActor [weak self] in
            await self?.refreshVerifiedInputsNow(using: coreLoop)
        }
    }

    private func refreshNotificationPermission() async {
        let notificationStatus = await notificationManager.authorizationStatus()
        if notificationPermission != notificationStatus {
            notificationPermission = notificationStatus
            persistNotificationPermission()
        }
    }

    private func refreshVerifiedInputsNow(using coreLoop: FirstPlayableStore) async {
        let samples = await healthKitManager.recentSamples(since: lastHealthKitSyncAt)
        for sample in samples {
            if let vowID = coreLoop.matchingVerifiedVowID(for: sample.domain) {
                coreLoop.recordVerifiedCompletion(
                    vowID: vowID,
                    sourceEventID: sample.sourceEventID,
                    localDate: sample.localDate,
                    domain: sample.domain,
                    amount: sample.durationMinutes ?? sample.quantity ?? 1
                )
            }
        }

        lastHealthKitSyncAt = .now
        persistLastHealthKitSync()
        if samples.isEmpty == false {
            accountNotice = "Verified inputs were refreshed from HealthKit."
        }
    }

    private func buildGlancePayload(for coreLoop: FirstPlayableStore) -> GlanceSurfacePayload {
        let reminderTime = coreLoop.activeVows
            .compactMap(\.schedule.reminderLocalTime)
            .first ?? "08:00"
        let hour = Int(reminderTime.split(separator: ":").first ?? "8") ?? 8
        let minute = Int(reminderTime.split(separator: ":").dropFirst().first ?? "0") ?? 0
        let topChain = coreLoop.activeVows.map(\.chainLength).max() ?? 0

        return GlanceSurfacePayload(
            generatedAt: isoFormatter.string(from: .now),
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
    }

    private func buildNotificationPlan(for coreLoop: FirstPlayableStore) -> NotificationPlan {
        let maxDailyReminders = Int((try? remoteConfigClient.loadDefaults().reminders["max_daily_reminders"]) ?? 2)
        var items: [NotificationPlanItem] = coreLoop.activeVows.compactMap { vow in
            guard let reminderTime = vow.schedule.reminderLocalTime, let components = parseTime(reminderTime) else {
                return nil
            }
            return NotificationPlanItem(
                id: "notif.vow.\(vow.id)",
                kind: .vowReminder,
                title: "Today's vow reminder",
                body: "\(vow.title) is still waiting for you in Aevora.",
                deliveryHourLocal: components.hour,
                deliveryMinuteLocal: components.minute,
                destination: .today,
                vowID: vow.id
            )
        }

        if coreLoop.completionDayCount > 0 {
            items.append(
                NotificationPlanItem(
                    id: "notif.witness",
                    kind: .witnessPrompt,
                    title: coreLoop.copy.text("notifications.witness_title", fallback: "The district is waiting"),
                    body: coreLoop.chapterState.tomorrowPrompt,
                    deliveryHourLocal: 20,
                    deliveryMinuteLocal: 0,
                    destination: .world,
                    vowID: nil
                )
            )
        }

        if coreLoop.activeVows.contains(where: { $0.statusLabel == "Cooling" }) {
            items.append(
                NotificationPlanItem(
                    id: "notif.cooling",
                    kind: .streakRisk,
                    title: "A promise is cooling",
                    body: "A quick return is enough. Manual logging still counts tonight.",
                    deliveryHourLocal: 18,
                    deliveryMinuteLocal: 30,
                    destination: .today,
                    vowID: nil
                )
            )
        }

        if coreLoop.chapterState.chapterID == "chapter_one" {
            items.append(
                NotificationPlanItem(
                    id: "notif.chapter",
                    kind: .chapterReady,
                    title: "Your next chapter beat is ready",
                    body: "Open the Quest Journal and see what Ember Quay is asking next.",
                    deliveryHourLocal: 21,
                    deliveryMinuteLocal: 0,
                    destination: .questJournal,
                    vowID: nil
                )
            )
        }

        return NotificationPlan(
            generatedAt: .now,
            items: Array(items.prefix(max(maxDailyReminders, 1) + 2))
        )
    }

    private func parseTime(_ value: String) -> (hour: Int, minute: Int)? {
        let parts = value.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else {
            return nil
        }
        return (hour, minute)
    }

    private func persistSubscription() {
        if let payload = try? encoder.encode(subscriptionState) {
            try? repository.saveSubscriptionState(payload: payload, tier: subscriptionState.tier.rawValue)
        }
    }

    private func persistNotificationPermission() {
        UserDefaults.standard.set(notificationPermission.rawValue, forKey: Self.notificationPermissionKey)
    }

    private func persistHealthKitPermission() {
        UserDefaults.standard.set(healthKitPermission.rawValue, forKey: Self.healthKitPermissionKey)
    }

    private func persistLastHealthKitSync() {
        UserDefaults.standard.set(lastHealthKitSyncAt.map(isoFormatter.string(from:)), forKey: Self.lastHealthKitSyncKey)
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
    private static let healthKitPermissionKey = "account.healthkit.permission.v1"
    private static let lastHealthKitSyncKey = "account.healthkit.last-sync.v1"
}
