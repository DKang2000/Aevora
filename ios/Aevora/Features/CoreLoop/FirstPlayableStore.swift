import Foundation
import SwiftUI

struct CompletionHistoryEntry: Identifiable, Equatable, Codable {
    let id: String
    let localDate: String
    let progressValue: Int
    let progressPercent: Int
    let progressState: String

    init(
        id: String = UUID().uuidString,
        localDate: String,
        progressValue: Int,
        progressPercent: Int,
        progressState: String
    ) {
        self.id = id
        self.localDate = localDate
        self.progressValue = progressValue
        self.progressPercent = progressPercent
        self.progressState = progressState
    }
}

struct PlayableVow: Identifiable, Equatable, Codable {
    struct Schedule: Equatable, Codable {
        let cadence: String
        let activeWeekdays: [String]
        let reminderLocalTime: String?
    }

    let id: String
    var title: String
    let type: String
    let category: String
    let difficulty: String
    let targetValue: Int
    let targetUnit: String
    let schedule: Schedule
    var progressToday: Int
    var isCompleteToday: Bool
    var chainLength: Int
    var bestChain: Int
    var statusLabel: String
    var lastCompletedLocalDate: String?
    var history: [CompletionHistoryEntry]
}

struct OnboardingAvatarDraft: Equatable, Codable {
    var displayName = "Wayfarer"
    var pronouns = ""
    var silhouetteId = "silhouette_oven_apron"
    var paletteId = "palette_ember_ochre"
    var accessoryIds = ["accessory_flour_wrap"]
}

struct ChapterCardState: Equatable, Codable {
    var chapterID: String
    var title: String
    var summary: String
    var currentDay: Int
    var chapterLength: Int
    var progressPercent: Double
    var tomorrowPrompt: String
    var objectiveTitle: String
    var statusNote: String
    var entitlementStatus: String
}

struct DistrictWitnessState: Equatable, Codable {
    var stageID: String
    var stageTitle: String
    var moodText: String
    var worldChangeText: String
    var magicalMomentTitle: String
    var magicalMomentBody: String
    var visibleNPCIDs: [String]
    var problemTitle: String
    var problemSummary: String
    var problemProgressPercent: Double
}

struct RewardPresentationState: Identifiable, Equatable {
    let id = UUID()
    let resonance: Int
    let gold: Int
    let worldChangeText: String
    let magicalMomentTitle: String?
    let magicalMomentBody: String?
    let leveledUp: Bool
    let unlockedItemNames: [String]
}

struct InventoryItemState: Identifiable, Equatable, Codable {
    let id: String
    let itemDefinitionId: String
    let name: String
    let summary: String
    let bucket: String
    let rarity: String
    let earnedFrom: String
    var status: String
    let slot: String

    init(
        id: String,
        itemDefinitionId: String,
        name: String,
        summary: String,
        bucket: String,
        rarity: String,
        earnedFrom: String,
        status: String,
        slot: String
    ) {
        self.id = id
        self.itemDefinitionId = itemDefinitionId
        self.name = name
        self.summary = summary
        self.bucket = bucket
        self.rarity = rarity
        self.earnedFrom = earnedFrom
        self.status = status
        self.slot = slot
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case itemDefinitionId
        case name
        case summary
        case bucket
        case rarity
        case earnedFrom
        case status
        case slot
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        itemDefinitionId = try container.decode(String.self, forKey: .itemDefinitionId)
        name = try container.decode(String.self, forKey: .name)
        summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? name
        bucket = try container.decode(String.self, forKey: .bucket)
        rarity = try container.decode(String.self, forKey: .rarity)
        earnedFrom = try container.decode(String.self, forKey: .earnedFrom)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? "stored"
        slot = try container.decodeIfPresent(String.self, forKey: .slot) ?? "display"
    }
}

struct ShopOfferState: Identifiable, Equatable {
    let id: String
    let itemDefinitionId: String
    let itemName: String
    let itemSummary: String
    let priceGold: Int
    let vendorNpcID: String
    let entitlementGate: String
    let chapterGate: String
    let canAfford: Bool
    let isOwned: Bool
    let isLocked: Bool
    let remainingStock: Int
}

struct WorldAnchorState: Identifiable, Equatable {
    let id: String
    let title: String
    let npcIDs: [String]
}

struct HearthState: Equatable {
    let title: String
    let summary: String
    let unlockedPropNames: [String]
    let chapterClosureReady: Bool
}

struct ReminderPromptState: Identifiable, Equatable {
    let id: String
    let title: String
    let body: String
}

enum OnboardingFlowStep: Int, CaseIterable {
    case welcomePromise
    case problemSolution
    case signIn
    case goals
    case lifeAreas
    case blocker
    case dailyLoad
    case tone
    case family
    case identity
    case avatar
    case starterVows
    case questPreview
    case magicalMoment
    case softPaywall
}

enum LocalCompletionSource: String, Codable {
    case manual
    case healthkit
    case shortcut

    var apiValue: String {
        switch self {
        case .healthkit:
            return "healthkit"
        case .manual, .shortcut:
            return "manual"
        }
    }
}

private struct CoreLoopSnapshot: Codable {
    var onboardingStep: Int
    var hasStartedOnboarding: Bool
    var hasCompletedOnboarding: Bool
    var authMode: String
    var selectedGoals: [String]
    var selectedLifeAreas: [String]
    var selectedBlocker: String
    var dailyLoad: Int
    var toneMode: String
    var selectedFamilyID: String
    var selectedIdentityID: String
    var avatarDraft: OnboardingAvatarDraft
    var recommendedVows: [PlayableVow]
    var activeVows: [PlayableVow]
    var availableEmbers: Int
    var heat: Int
    var rank: Int
    var lifetimeResonance: Int
    var todayGold: Int
    var completionDayCount: Int
    var completedDates: [String]
    var dayCompletionCounts: [String: Int]
    var hasShownSoftPaywall: Bool
    var inventoryItems: [InventoryItemState]
    var currentWorldAnchorID: String?
    var verifiedSourceEventIDs: [String]
    var verifiedCompletionDatesByVowID: [String: [String]]

    init(
        onboardingStep: Int,
        hasStartedOnboarding: Bool,
        hasCompletedOnboarding: Bool,
        authMode: String,
        selectedGoals: [String],
        selectedLifeAreas: [String],
        selectedBlocker: String,
        dailyLoad: Int,
        toneMode: String,
        selectedFamilyID: String,
        selectedIdentityID: String,
        avatarDraft: OnboardingAvatarDraft,
        recommendedVows: [PlayableVow],
        activeVows: [PlayableVow],
        availableEmbers: Int,
        heat: Int,
        rank: Int,
        lifetimeResonance: Int,
        todayGold: Int,
        completionDayCount: Int,
        completedDates: [String],
        dayCompletionCounts: [String: Int],
        hasShownSoftPaywall: Bool,
        inventoryItems: [InventoryItemState],
        currentWorldAnchorID: String?,
        verifiedSourceEventIDs: [String],
        verifiedCompletionDatesByVowID: [String: [String]]
    ) {
        self.onboardingStep = onboardingStep
        self.hasStartedOnboarding = hasStartedOnboarding
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.authMode = authMode
        self.selectedGoals = selectedGoals
        self.selectedLifeAreas = selectedLifeAreas
        self.selectedBlocker = selectedBlocker
        self.dailyLoad = dailyLoad
        self.toneMode = toneMode
        self.selectedFamilyID = selectedFamilyID
        self.selectedIdentityID = selectedIdentityID
        self.avatarDraft = avatarDraft
        self.recommendedVows = recommendedVows
        self.activeVows = activeVows
        self.availableEmbers = availableEmbers
        self.heat = heat
        self.rank = rank
        self.lifetimeResonance = lifetimeResonance
        self.todayGold = todayGold
        self.completionDayCount = completionDayCount
        self.completedDates = completedDates
        self.dayCompletionCounts = dayCompletionCounts
        self.hasShownSoftPaywall = hasShownSoftPaywall
        self.inventoryItems = inventoryItems
        self.currentWorldAnchorID = currentWorldAnchorID
        self.verifiedSourceEventIDs = verifiedSourceEventIDs
        self.verifiedCompletionDatesByVowID = verifiedCompletionDatesByVowID
    }

    private enum CodingKeys: String, CodingKey {
        case onboardingStep
        case hasStartedOnboarding
        case hasCompletedOnboarding
        case authMode
        case selectedGoals
        case selectedLifeAreas
        case selectedBlocker
        case dailyLoad
        case toneMode
        case selectedFamilyID
        case selectedIdentityID
        case avatarDraft
        case recommendedVows
        case activeVows
        case availableEmbers
        case heat
        case rank
        case lifetimeResonance
        case todayGold
        case completionDayCount
        case completedDates
        case dayCompletionCounts
        case hasShownSoftPaywall
        case inventoryItems
        case currentWorldAnchorID
        case verifiedSourceEventIDs
        case verifiedCompletionDatesByVowID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onboardingStep = try container.decode(Int.self, forKey: .onboardingStep)
        hasStartedOnboarding = try container.decode(Bool.self, forKey: .hasStartedOnboarding)
        hasCompletedOnboarding = try container.decode(Bool.self, forKey: .hasCompletedOnboarding)
        authMode = try container.decode(String.self, forKey: .authMode)
        selectedGoals = try container.decode([String].self, forKey: .selectedGoals)
        selectedLifeAreas = try container.decode([String].self, forKey: .selectedLifeAreas)
        selectedBlocker = try container.decode(String.self, forKey: .selectedBlocker)
        dailyLoad = try container.decode(Int.self, forKey: .dailyLoad)
        toneMode = try container.decode(String.self, forKey: .toneMode)
        selectedFamilyID = try container.decode(String.self, forKey: .selectedFamilyID)
        selectedIdentityID = try container.decode(String.self, forKey: .selectedIdentityID)
        avatarDraft = try container.decode(OnboardingAvatarDraft.self, forKey: .avatarDraft)
        recommendedVows = try container.decode([PlayableVow].self, forKey: .recommendedVows)
        activeVows = try container.decode([PlayableVow].self, forKey: .activeVows)
        availableEmbers = try container.decode(Int.self, forKey: .availableEmbers)
        heat = try container.decode(Int.self, forKey: .heat)
        rank = try container.decode(Int.self, forKey: .rank)
        lifetimeResonance = try container.decode(Int.self, forKey: .lifetimeResonance)
        todayGold = try container.decode(Int.self, forKey: .todayGold)
        completionDayCount = try container.decode(Int.self, forKey: .completionDayCount)
        completedDates = try container.decode([String].self, forKey: .completedDates)
        dayCompletionCounts = try container.decode([String: Int].self, forKey: .dayCompletionCounts)
        hasShownSoftPaywall = try container.decode(Bool.self, forKey: .hasShownSoftPaywall)
        inventoryItems = try container.decode([InventoryItemState].self, forKey: .inventoryItems)
        currentWorldAnchorID = try container.decodeIfPresent(String.self, forKey: .currentWorldAnchorID)
        verifiedSourceEventIDs = try container.decodeIfPresent([String].self, forKey: .verifiedSourceEventIDs) ?? []
        verifiedCompletionDatesByVowID = try container.decodeIfPresent([String: [String]].self, forKey: .verifiedCompletionDatesByVowID) ?? [:]
    }
}

@MainActor
final class FirstPlayableStore: ObservableObject {
    @Published var onboardingStep = 0
    @Published var hasStartedOnboarding = false
    @Published var hasCompletedOnboarding = false
    @Published var authMode = "guest"
    @Published var authErrorMessage: String?

    @Published var selectedGoals: Set<String> = []
    @Published var selectedLifeAreas: Set<String> = []
    @Published var selectedBlocker = "I forget"
    @Published var dailyLoad = 3
    @Published var toneMode = "balanced"
    @Published var selectedFamilyID = "hearthkeeper"
    @Published var selectedIdentityID = "idn_baker"
    @Published var avatarDraft = OnboardingAvatarDraft()
    @Published var recommendedVows: [PlayableVow] = []
    @Published var activeVows: [PlayableVow] = []

    @Published var chapterState: ChapterCardState
    @Published var districtState: DistrictWitnessState
    @Published var rewardPresentation: RewardPresentationState?
    @Published var inventoryItems: [InventoryItemState] = []
    @Published var hearthState: HearthState
    @Published var reminderPrompts: [ReminderPromptState] = []
    @Published var isQuestJournalPresented = false
    @Published var isProgressSheetPresented = false
    @Published var progressSheetVowID: String?
    @Published var progressSheetValue = 1
    @Published var isSoftPaywallPresented = false
    @Published var currentWorldAnchorID = "oven_square"

    @Published var availableEmbers = 2
    @Published var heat = 0
    @Published var rank = 1
    @Published var lifetimeResonance = 0
    @Published var todayGold = 0
    @Published var completionDayCount = 0

    let content: LaunchContent
    let copy: CopyCatalog

    private let repository: SwiftDataRepository
    private let syncQueue: SyncQueue
    private let analyticsClient: AnalyticsClient
    private let syncStatusStore: SyncStatusStore
    var onStateChanged: ((FirstPlayableStore) -> Void)?
    private var hasShownSoftPaywall = false
    private var completedDates: [String] = []
    private var dayCompletionCounts: [String: Int] = [:]
    private var verifiedSourceEventIDs: [String] = []
    private var verifiedCompletionDatesByVowID: [String: [String]] = [:]

    var goldBalance: Int {
        todayGold
    }

    var currentOnboardingFlowStep: OnboardingFlowStep {
        OnboardingFlowStep(rawValue: onboardingStep) ?? .welcomePromise
    }

    var onboardingProgressValue: Double {
        Double(min(currentOnboardingFlowStep.rawValue + 1, OnboardingFlowStep.allCases.count))
    }

    var onboardingProgressTotal: Double {
        Double(OnboardingFlowStep.allCases.count)
    }

    var selectedIdentityDisplayName: String {
        guard let identity = content.identityShells.first(where: { $0.id == selectedIdentityID }) else {
            return Self.readableAvatarLabel(selectedIdentityID, prefix: "idn_")
        }
        return copy.text(identity.displayNameKey, fallback: Self.readableAvatarLabel(identity.id, prefix: "idn_"))
    }

    var onboardingAvatarStepState: OnboardingAvatarStepState {
        let silhouettes = Self.uniqueAvatarOptionIDs(
            content.identityShells
                .filter { $0.originFamilyId == selectedFamilyID }
                .compactMap { $0.defaultAvatar?.silhouetteId },
            fallback: avatarDraft.silhouetteId
        )
        let palettes = Self.uniqueAvatarOptionIDs(
            content.identityShells
                .filter { $0.originFamilyId == selectedFamilyID }
                .compactMap { $0.defaultAvatar?.paletteId },
            fallback: avatarDraft.paletteId
        )

        return OnboardingAvatarStepState(
            configuration: avatarPreviewConfiguration(
                statusLine: "One preview, fast silhouette and palette choices, then back to your starter vows."
            ),
            silhouetteOptions: silhouettes.map { id in
                AvatarSelectionOption(
                    id: id,
                    label: AvatarPresentationCatalog.silhouette(for: id)?.label ?? Self.readableAvatarLabel(id, prefix: "silhouette_")
                )
            },
            paletteOptions: palettes.map { id in
                AvatarSelectionOption(
                    id: id,
                    label: AvatarPresentationCatalog.palette(for: id)?.label ?? Self.readableAvatarLabel(id, prefix: "palette_")
                )
            }
        )
    }

    var hearthAvatarPreviewConfiguration: AvatarPreviewConfiguration {
        avatarPreviewConfiguration(statusLine: hearthState.summary)
    }

    var onboardingQuestPreviewTitle: String {
        let starterDay = content.starterArcDays.first
        let quest = content.questTemplates.first(where: { $0.id == starterDay?.questId })
        return copy.text(quest?.titleKey ?? "", fallback: "The Ember That Returned")
    }

    var onboardingQuestPreviewSummary: String {
        let starterDay = content.starterArcDays.first
        let quest = content.questTemplates.first(where: { $0.id == starterDay?.questId })
        return copy.text(quest?.summaryKey ?? "", fallback: "Keep one small vow and the district answers.")
    }

    var onboardingQuestTomorrowPrompt: String {
        let starterDay = content.starterArcDays.first
        return copy.text(starterDay?.tomorrowPromptKey ?? "", fallback: "Return tomorrow to keep the quarter moving.")
    }

    var onboardingMagicalMomentPreviewTitle: String {
        let momentID = content.starterArcDays.first?.worldMomentId
        let moment = content.magicalMoments.first(where: { $0.id == momentID }) ?? content.magicalMoments.first
        return copy.text(moment?.titleKey ?? "", fallback: "The city remembers those who keep cadence.")
    }

    var onboardingMagicalMomentPreviewBody: String {
        let momentID = content.starterArcDays.first?.worldMomentId
        let moment = content.magicalMoments.first(where: { $0.id == momentID }) ?? content.magicalMoments.first
        return copy.text(moment?.summaryKey ?? "", fallback: districtState.worldChangeText)
    }

    var worldAnchors: [WorldAnchorState] {
        [
            WorldAnchorState(id: "quay_gate", title: "Quay Gate", npcIDs: visibleNPCIDs(for: "quay_gate")),
            WorldAnchorState(id: "oven_square", title: "Oven Square", npcIDs: visibleNPCIDs(for: "oven_square")),
            WorldAnchorState(id: "lantern_stall", title: "Lantern Stall", npcIDs: visibleNPCIDs(for: "lantern_stall"))
        ]
    }

    var availableShopOffers: [ShopOfferState] {
        let subscription = currentSubscriptionSnapshot()
        return content.shopOffers.map { offer in
            let definition = content.itemDefinitions.first(where: { $0.id == offer.itemDefinitionId })
            let owned = inventoryItems.contains(where: { $0.itemDefinitionId == offer.itemDefinitionId }) && !(offer.repeatable ?? false)
            let chapterLocked = (offer.chapterGate ?? "starter_arc") == "chapter_one" && completionDayCount < 7
            let premiumLocked = offer.entitlementGate == "premium" && !subscription.hasPremiumBreadth
            let remainingStock = owned ? 0 : max(1, offer.stockLimit ?? 1)

            return ShopOfferState(
                id: offer.id,
                itemDefinitionId: offer.itemDefinitionId,
                itemName: copy.text(definition?.nameKey ?? "", fallback: offer.itemDefinitionId),
                itemSummary: copy.text(definition?.summaryKey ?? "", fallback: copy.text("shop.locked_label", fallback: "")),
                priceGold: offer.priceGold,
                vendorNpcID: offer.vendorNpcId ?? "maerin_vale",
                entitlementGate: offer.entitlementGate,
                chapterGate: offer.chapterGate ?? "starter_arc",
                canAfford: todayGold >= offer.priceGold,
                isOwned: owned,
                isLocked: owned || chapterLocked || premiumLocked,
                remainingStock: remainingStock
            )
        }
    }

    private func avatarPreviewConfiguration(statusLine: String) -> AvatarPreviewConfiguration {
        AvatarPreviewConfiguration(
            displayName: avatarDraft.displayName,
            pronouns: avatarDraft.pronouns,
            identityName: selectedIdentityDisplayName,
            silhouetteId: avatarDraft.silhouetteId,
            paletteId: avatarDraft.paletteId,
            accessoryLabel: currentAccessoryLabel,
            statusLine: statusLine
        )
    }

    private var currentAccessoryLabel: String {
        guard let accessoryID = avatarDraft.accessoryIds.first else {
            return ""
        }
        return AvatarPresentationCatalog.accessory(for: accessoryID)?.label
            ?? Self.readableAvatarLabel(accessoryID, prefix: "accessory_")
    }

    init(
        repository: SwiftDataRepository,
        syncQueue: SyncQueue,
        analyticsClient: AnalyticsClient,
        syncStatusStore: SyncStatusStore,
        contentLoader: LaunchContentLoader = LaunchContentLoader(),
        copy: CopyCatalog = CopyCatalog()
    ) {
        self.repository = repository
        self.syncQueue = syncQueue
        self.analyticsClient = analyticsClient
        self.syncStatusStore = syncStatusStore
        self.copy = copy
        self.content = (try? contentLoader.load()) ?? .fallback

        let initialChapter = Self.chapterState(
            from: self.content,
            copy: copy,
            completionDayCount: 0,
            subscription: .free
        )
        let initialDistrict = Self.districtState(
            from: self.content,
            copy: copy,
            completionDayCount: 0,
            subscription: .free
        )
        chapterState = initialChapter
        districtState = initialDistrict
        hearthState = Self.hearthState(from: self.content, copy: copy, completionDayCount: 0, inventoryItems: [])
        updateAvatarDefaults()
        hydrateFromSnapshotIfAvailable()
        refreshDerivedState()
    }

    func beginGuestMode() {
        authMode = "guest"
        hasStartedOnboarding = true
        persistSnapshot()
        track(.onboardingStarted, surface: "onboarding", properties: ["auth_mode": authMode])
    }

    func completeAppleSignIn(token: String) {
        guard !token.isEmpty else {
            authErrorMessage = "Apple sign-in could not be completed."
            return
        }

        authMode = "registered"
        hasStartedOnboarding = true
        authErrorMessage = nil
        persistSnapshot()
        track(.onboardingStarted, surface: "onboarding", properties: ["auth_mode": authMode])
    }

    func goBackOnboarding() {
        onboardingStep = max(0, onboardingStep - 1)
        persistSnapshot()
    }

    func advanceOnboarding() {
        let currentStep = currentOnboardingFlowStep

        if currentStep == .signIn && !hasStartedOnboarding {
            return
        }

        if currentStep == .family {
            updateAvatarDefaults()
            track(.originFamilySelected, surface: "onboarding", properties: ["family_id": selectedFamilyID])
        }

        if currentStep == .identity {
            updateAvatarDefaults()
            track(.identitySelected, surface: "onboarding", properties: ["identity_id": selectedIdentityID])
        }

        if currentStep == .avatar {
            generateStarterRecommendations()
            track(.avatarCreated, surface: "onboarding", properties: ["silhouette_id": avatarDraft.silhouetteId])
        }

        if currentStep == .magicalMoment && !hasShownSoftPaywall {
            hasShownSoftPaywall = true
            track(.paywallViewed, surface: "paywall", properties: ["trigger": "after_first_magical_moment"])
        }

        onboardingStep = min(onboardingStep + 1, OnboardingFlowStep.softPaywall.rawValue)
        persistSnapshot()
        track(.onboardingStepCompleted, surface: "onboarding", properties: ["step_index": "\(onboardingStep)"])
    }

    func generateStarterRecommendations() {
        let limit = min(max(dailyLoad, 3), 3)
        let lifeAreas = selectedLifeAreas.isEmpty ? Set(["Physical", "Emotional", "Career"]) : selectedLifeAreas
        let blocker = selectedBlocker
        let tone = toneMode

        var chosen: [LaunchContent.StarterVowTemplate] = []
        for area in lifeAreas {
            if let match = content.starterVowTemplates.first(where: { template in
                template.category == area &&
                template.toneBias.contains(tone) &&
                (template.blockerMatches.contains(blocker) || template.blockerMatches.isEmpty)
            }) {
                chosen.append(match)
            }
        }

        if chosen.count < limit {
            for template in content.starterVowTemplates where !chosen.map(\.id).contains(template.id) {
                chosen.append(template)
                if chosen.count == limit {
                    break
                }
            }
        }

        recommendedVows = Array(chosen.prefix(limit)).map { template in
            Self.playableVow(from: template, copy: copy)
        }
        persistSnapshot()
        track(.starterVowRecommended, surface: "onboarding", properties: ["count": "\(recommendedVows.count)"])
    }

    func replaceRecommendation(_ vowID: String) {
        guard let index = recommendedVows.firstIndex(where: { $0.id == vowID }),
              let replacement = content.starterVowTemplates.first(where: { template in
                  !recommendedVows.map(\.title).contains(copy.text(template.titleKey, fallback: template.titleKey))
              }) else {
            return
        }

        recommendedVows[index] = Self.playableVow(from: replacement, copy: copy)
        persistSnapshot()
        track(.starterVowEdited, surface: "onboarding", properties: ["vow_id": vowID])
    }

    func finishOnboarding() {
        activeVows = recommendedVows
        hasCompletedOnboarding = true
        hasShownSoftPaywall = true
        isSoftPaywallPresented = false
        onboardingStep = 0
        refreshDerivedState()

        do {
            try repository.saveSession(UserSessionSnapshot(id: "current-user", authMode: authMode, timezone: TimeZone.current.identifier))
            for vow in activeVows {
                try repository.saveVow(LocalVowRecord(id: vow.id, title: vow.title, type: vow.type, lifecycle: "active"))
            }
        } catch {
            authErrorMessage = "Local setup could not be saved."
        }

        persistSnapshot()
        track(.starterVowAccepted, surface: "onboarding", properties: ["count": "\(activeVows.count)"])
        track(.onboardingCompleted, surface: "onboarding", properties: ["active_vows": "\(activeVows.count)"])
    }

    func quickLog(_ vow: PlayableVow) {
        if vow.type == "binary" {
            recordCompletion(vowID: vow.id, amount: vow.targetValue)
        } else {
            progressSheetVowID = vow.id
            progressSheetValue = max(vow.targetValue, 1)
            isProgressSheetPresented = true
        }
    }

    func confirmProgressSheet() {
        guard let progressSheetVowID else { return }
        recordCompletion(vowID: progressSheetVowID, amount: progressSheetValue)
        isProgressSheetPresented = false
    }

    func recordCompletion(vowID: String, amount: Int) {
        recordCompletion(vowID: vowID, amount: amount, localDate: Self.localDateString(), source: .manual)
    }

    func recordShortcutCompletion(vowID: String, amount: Int) {
        recordCompletion(vowID: vowID, amount: amount, localDate: Self.localDateString(), source: .shortcut)
    }

    func recordCompletion(vowID: String, amount: Int, localDate: String) {
        recordCompletion(vowID: vowID, amount: amount, localDate: localDate, source: .manual)
    }

    func recordCompletion(vowID: String, amount: Int, localDate: String, source: LocalCompletionSource, enqueueSync: Bool = true) {
        guard let index = activeVows.firstIndex(where: { $0.id == vowID }) else { return }
        var vow = activeVows[index]

        if vow.lastCompletedLocalDate == localDate && vow.isCompleteToday {
            return
        }

        let progress = min(amount, Int(Double(vow.targetValue) * 1.2))
        let progressPercent = max(30, Int((Double(progress) / Double(max(vow.targetValue, 1))) * 100))
        let isComplete = progress >= vow.targetValue || vow.type == "binary"
        let chainStatus = advanceChainState(for: vow, localDate: localDate)
        let resonance = Int((Double(Self.baseResonance(for: vow.type)) * Self.difficultyMultiplier(for: vow.difficulty) * Double(isComplete ? 100 : progressPercent)) / 100.0)
        var gold = Int((Double(Self.baseGold(for: vow.type)) * Double(isComplete ? 100 : progressPercent)) / 100.0)
        let wasFirstCompletionForDay = (dayCompletionCounts[localDate] ?? 0) == 0
        if wasFirstCompletionForDay {
            gold += 2
        }

        dayCompletionCounts[localDate, default: 0] += 1
        if !completedDates.contains(localDate) {
            completedDates.append(localDate)
            completedDates.sort()
        }

        let didCompleteAll = activeVows.count > 0 && activeVows.enumerated().allSatisfy { offset, entry in
            if offset == index {
                return true
            }
            return entry.lastCompletedLocalDate == localDate && entry.isCompleteToday
        }
        if didCompleteAll {
            gold += 5
        }

        let previousRank = rank
        rank = Self.rank(for: lifetimeResonance + resonance)
        lifetimeResonance += resonance
        todayGold += gold
        heat = min(5, heat + 1)

        vow.progressToday = progress
        vow.isCompleteToday = isComplete
        vow.chainLength = chainStatus.chainLength
        vow.bestChain = max(vow.bestChain, chainStatus.chainLength)
        vow.statusLabel = chainStatus.statusLabel
        vow.lastCompletedLocalDate = localDate
        vow.history.insert(
            CompletionHistoryEntry(
                localDate: localDate,
                progressValue: progress,
                progressPercent: progressPercent,
                progressState: isComplete ? "complete" : "partial"
            ),
            at: 0
        )
        activeVows[index] = vow

        completionDayCount = completedDates.count
        unlockInventoryIfNeeded()
        refreshDerivedState()

        let safeDayIndex = max(0, min(max(completionDayCount, 1) - 1, content.starterArcDays.count - 1))
        let currentDayMoment = content.starterArcDays.indices.contains(safeDayIndex)
            ? content.magicalMoments.first(where: { $0.id == content.starterArcDays[safeDayIndex].worldMomentId })
            : content.magicalMoments.first
        let unlockedNames = inventoryItems
            .filter { $0.earnedFrom.hasSuffix(localDate) }
            .map(\.name)
        rewardPresentation = RewardPresentationState(
            resonance: resonance,
            gold: gold,
            worldChangeText: districtState.worldChangeText,
            magicalMomentTitle: wasFirstCompletionForDay ? currentDayMoment.map { copy.text($0.titleKey, fallback: $0.titleKey) } : nil,
            magicalMomentBody: wasFirstCompletionForDay ? currentDayMoment.map { copy.text($0.summaryKey, fallback: $0.summaryKey) } : nil,
            leveledUp: rank > previousRank,
            unlockedItemNames: unlockedNames
        )

        if enqueueSync {
            enqueueCompletionPayload(for: vow, localDate: localDate, progress: progress, isComplete: isComplete, source: source)
        }
        persistSnapshot()
        track(.vowCompleted, surface: "today", properties: ["vow_id": vow.id, "progress_percent": "\(progressPercent)"])
        track(.resonanceAwarded, surface: "reward", properties: ["amount": "\(resonance)"])
        track(.goldAwarded, surface: "reward", properties: ["amount": "\(gold)"])
        if source == .shortcut {
            track(.shortcutInvoked, surface: "today", properties: ["vow_id": vow.id])
        }
        if wasFirstCompletionForDay {
            track(.dayCompletedFirstVow, surface: "today", properties: ["local_date": localDate])
            track(.firstMagicalMomentViewed, surface: "reward", properties: ["moment_id": content.starterArcDays.first?.worldMomentId ?? "oven_glow"])
            track(.districtProgressed, surface: "world", properties: ["district_id": "ember_quay", "stage_id": districtState.stageID])
        }
    }

    func recordVerifiedCompletion(
        vowID: String,
        sourceEventID: String,
        localDate: String,
        domain: HealthKitDomain,
        amount: Int
    ) {
        guard verifiedSourceEventIDs.contains(sourceEventID) == false else {
            return
        }
        verifiedSourceEventIDs.append(sourceEventID)
        verifiedCompletionDatesByVowID[vowID, default: []].append(localDate)

        let alreadyCompletedLocally = activeVows.first(where: { $0.id == vowID })?.history.contains(where: { $0.localDate == localDate }) ?? false
        if !alreadyCompletedLocally {
            recordCompletion(vowID: vowID, amount: amount, localDate: localDate, source: .healthkit, enqueueSync: false)
        } else {
            persistSnapshot()
        }

        enqueueVerifiedCompletionPayload(
            vowID: vowID,
            sourceEventID: sourceEventID,
            localDate: localDate,
            domain: domain,
            amount: amount
        )
        track(.verifiedCompletionImported, surface: "today", properties: ["vow_id": vowID, "domain": domain.rawValue])
    }

    func questStatus(for day: Int) -> String {
        if day < chapterState.currentDay {
            return "Completed"
        }
        if day == chapterState.currentDay {
            return completionDayCount >= 7 ? "Complete" : "Current"
        }
        return "Upcoming"
    }

    func npcSummary(for npcID: String) -> String {
        guard let npc = content.npcs.first(where: { $0.id == npcID }) else {
            return ""
        }
        return copy.text(npc.summaryKey, fallback: npc.summaryKey)
    }

    func npcName(for npcID: String) -> String {
        guard let npc = content.npcs.first(where: { $0.id == npcID }) else {
            return npcID
        }
        return copy.text(npc.displayNameKey, fallback: npc.displayNameKey)
    }

    func dialogueLine(for npcID: String) -> String {
        let key: String
        if chapterState.chapterID == "starter_arc" {
            switch (npcID, chapterState.currentDay) {
            case ("maerin_vale", 5...): key = "content.dialogue.maerin_vale.day_5"
            case ("maerin_vale", _): key = "content.dialogue.maerin_vale.day_1"
            case ("sera_quill", _): key = "content.dialogue.sera_quill.day_3"
            case ("tovan_hearth", 7...): key = "content.dialogue.tovan_hearth.day_7"
            case ("tovan_hearth", _): key = "content.dialogue.tovan_hearth.day_1"
            case ("brigant_hal", _): key = "content.dialogue.brigant_hal.day_4"
            case ("ilya_fen", _): key = "content.dialogue.ilya_fen.day_4"
            case ("pollen", _): key = "content.dialogue.pollen.day_3"
            default: key = "content.dialogue.maerin_vale.day_1"
            }
        } else if chapterState.currentDay >= 25 {
            key = "content.dialogue.\(npcID).chapter_one_end"
        } else if chapterState.currentDay >= 13 {
            key = "content.dialogue.\(npcID).chapter_one_mid"
        } else {
            key = "content.dialogue.\(npcID).chapter_one_intro"
        }

        return copy.text(key, fallback: npcSummary(for: npcID))
    }

    func nextActionText(for npcID: String) -> String {
        if chapterState.statusNote.isEmpty == false {
            return chapterState.statusNote
        }
        return chapterState.tomorrowPrompt
    }

    func matchingVerifiedVowID(for domain: HealthKitDomain) -> String? {
        activeVows.first(where: { supportsVerifiedDomain(domain, for: $0) })?.id
    }

    func completionBadge(for vowID: String) -> String? {
        let today = Self.localDateString()
        guard verifiedCompletionDatesByVowID[vowID]?.contains(today) == true else {
            return nil
        }
        return copy.text("healthkit.verified_badge", fallback: "Verified")
    }

    func itemName(for itemDefinitionID: String) -> String {
        guard let item = content.itemDefinitions.first(where: { $0.id == itemDefinitionID }) else {
            return itemDefinitionID
        }
        return copy.text(item.nameKey, fallback: itemDefinitionID)
    }

    func moveAvatar(to anchorID: String) {
        currentWorldAnchorID = anchorID
        track(.worldSceneOpened, surface: "world", properties: ["anchor_id": anchorID, "chapter_id": chapterState.chapterID])
        persistSnapshot()
    }

    func toggleItemApplied(_ itemID: String) {
        guard let index = inventoryItems.firstIndex(where: { $0.id == itemID }) else { return }
        inventoryItems[index].status = inventoryItems[index].status == "applied" ? "stored" : "applied"
        refreshDerivedState()
        persistSnapshot()
    }

    func purchaseOffer(_ offerID: String) {
        guard let offer = availableShopOffers.first(where: { $0.id == offerID }), !offer.isLocked, offer.canAfford else {
            return
        }
        guard let definition = content.itemDefinitions.first(where: { $0.id == offer.itemDefinitionId }) else {
            return
        }

        todayGold -= offer.priceGold
        inventoryItems.append(
            InventoryItemState(
                id: UUID().uuidString,
                itemDefinitionId: definition.id,
                name: copy.text(definition.nameKey, fallback: definition.id),
                summary: copy.text(definition.summaryKey ?? "", fallback: definition.id),
                bucket: definition.bucket,
                rarity: definition.rarity,
                earnedFrom: "shop:\(offer.id)",
                status: "stored",
                slot: definition.slot ?? "display"
            )
        )

        let payload: [String: Any] = [
            "offerId": offer.id,
            "source": "world_market"
        ]
        if let data = try? JSONSerialization.data(withJSONObject: payload) {
            Task {
                await syncQueue.enqueue(SyncOperation(operationType: .shopPurchase, endpointPath: "v1/shop/offers/\(offer.id)/purchase", payload: data))
                await syncStatusStore.refresh()
            }
        }

        track(.shopPurchaseCompleted, surface: "world", properties: ["offer_id": offer.id, "item_definition_id": offer.itemDefinitionId])
        refreshDerivedState()
        persistSnapshot()
    }

    func rewardDismissed() {
        rewardPresentation = nil
        if completionDayCount >= 1 && !hasShownSoftPaywall {
            isSoftPaywallPresented = true
            hasShownSoftPaywall = true
            persistSnapshot()
            track(.paywallViewed, surface: "paywall", properties: ["trigger": "after_first_magical_moment"])
        }
    }

    func dismissSoftPaywall() {
        isSoftPaywallPresented = false
    }

    func linkCurrentGuestAccount(identityToken: String) {
        guard authMode == "guest", !identityToken.isEmpty else {
            return
        }

        authMode = "registered"
        authErrorMessage = nil
        persistSnapshot()
    }

    func resetForDeletedAccount() {
        onboardingStep = 0
        hasStartedOnboarding = false
        hasCompletedOnboarding = false
        authMode = "guest"
        authErrorMessage = nil
        selectedGoals = []
        selectedLifeAreas = []
        selectedBlocker = "I forget"
        dailyLoad = 3
        toneMode = "balanced"
        selectedFamilyID = "hearthkeeper"
        selectedIdentityID = "idn_baker"
        avatarDraft = OnboardingAvatarDraft()
        recommendedVows = []
        activeVows = []
        rewardPresentation = nil
        inventoryItems = []
        currentWorldAnchorID = "oven_square"
        isQuestJournalPresented = false
        isProgressSheetPresented = false
        progressSheetVowID = nil
        progressSheetValue = 1
        isSoftPaywallPresented = false
        availableEmbers = 2
        heat = 0
        rank = 1
        lifetimeResonance = 0
        todayGold = 0
        completionDayCount = 0
        hasShownSoftPaywall = false
        completedDates = []
        dayCompletionCounts = [:]
        verifiedSourceEventIDs = []
        verifiedCompletionDatesByVowID = [:]
        updateAvatarDefaults()
        refreshDerivedState()
        persistSnapshot()
    }

    private func hydrateFromSnapshotIfAvailable() {
        guard let record = try? repository.fetchCoreLoopSnapshot(),
              let snapshot = try? JSONDecoder().decode(CoreLoopSnapshot.self, from: record.payload) else {
            return
        }

        onboardingStep = snapshot.onboardingStep
        hasStartedOnboarding = snapshot.hasStartedOnboarding
        hasCompletedOnboarding = snapshot.hasCompletedOnboarding
        authMode = snapshot.authMode
        selectedGoals = Set(snapshot.selectedGoals)
        selectedLifeAreas = Set(snapshot.selectedLifeAreas)
        selectedBlocker = snapshot.selectedBlocker
        dailyLoad = snapshot.dailyLoad
        toneMode = snapshot.toneMode
        selectedFamilyID = snapshot.selectedFamilyID
        selectedIdentityID = snapshot.selectedIdentityID
        avatarDraft = snapshot.avatarDraft
        recommendedVows = snapshot.recommendedVows
        activeVows = snapshot.activeVows
        availableEmbers = snapshot.availableEmbers
        heat = snapshot.heat
        rank = snapshot.rank
        lifetimeResonance = snapshot.lifetimeResonance
        todayGold = snapshot.todayGold
        completionDayCount = snapshot.completionDayCount
        completedDates = snapshot.completedDates
        dayCompletionCounts = snapshot.dayCompletionCounts
        hasShownSoftPaywall = snapshot.hasShownSoftPaywall
        inventoryItems = snapshot.inventoryItems
        currentWorldAnchorID = snapshot.currentWorldAnchorID ?? "oven_square"
        verifiedSourceEventIDs = snapshot.verifiedSourceEventIDs
        verifiedCompletionDatesByVowID = snapshot.verifiedCompletionDatesByVowID
    }

    private func persistSnapshot() {
        let snapshot = CoreLoopSnapshot(
            onboardingStep: onboardingStep,
            hasStartedOnboarding: hasStartedOnboarding,
            hasCompletedOnboarding: hasCompletedOnboarding,
            authMode: authMode,
            selectedGoals: Array(selectedGoals),
            selectedLifeAreas: Array(selectedLifeAreas),
            selectedBlocker: selectedBlocker,
            dailyLoad: dailyLoad,
            toneMode: toneMode,
            selectedFamilyID: selectedFamilyID,
            selectedIdentityID: selectedIdentityID,
            avatarDraft: avatarDraft,
            recommendedVows: recommendedVows,
            activeVows: activeVows,
            availableEmbers: availableEmbers,
            heat: heat,
            rank: rank,
            lifetimeResonance: lifetimeResonance,
            todayGold: todayGold,
            completionDayCount: completionDayCount,
            completedDates: completedDates,
            dayCompletionCounts: dayCompletionCounts,
            hasShownSoftPaywall: hasShownSoftPaywall,
            inventoryItems: inventoryItems,
            currentWorldAnchorID: currentWorldAnchorID,
            verifiedSourceEventIDs: verifiedSourceEventIDs,
            verifiedCompletionDatesByVowID: verifiedCompletionDatesByVowID
        )

        if let data = try? JSONEncoder().encode(snapshot) {
            try? repository.saveCoreLoopSnapshot(payload: data)
        }
        onStateChanged?(self)
    }

    private func refreshDerivedState() {
        let subscription = currentSubscriptionSnapshot()
        chapterState = Self.chapterState(from: content, copy: copy, completionDayCount: completionDayCount, subscription: subscription)
        districtState = Self.districtState(from: content, copy: copy, completionDayCount: completionDayCount, subscription: subscription)
        hearthState = Self.hearthState(from: content, copy: copy, completionDayCount: completionDayCount, inventoryItems: inventoryItems)
        reminderPrompts = buildReminderPrompts()
    }

    private func unlockInventoryIfNeeded() {
        let awardDefinitions: [(requiredDay: Int, itemID: String, earnedFrom: String)] = [
            (1, "ember_quay_token", "starter_day_1_reward"),
            (7, "hearth_apron_common", "starter_day_7_chest"),
            (14, "lantern_rack_prop", "chapter_one_preview_reward"),
            (37, "archive_map_cosmetic", "chapter_one_completion_reward")
        ]

        let localDate = completedDates.last ?? Self.localDateString()
        for award in awardDefinitions where completionDayCount >= award.requiredDay {
            guard inventoryItems.contains(where: { $0.itemDefinitionId == award.itemID }) == false,
                  let definition = content.itemDefinitions.first(where: { $0.id == award.itemID }) else {
                continue
            }
            inventoryItems.append(
                InventoryItemState(
                    id: UUID().uuidString,
                    itemDefinitionId: definition.id,
                    name: copy.text(definition.nameKey, fallback: definition.id),
                    summary: copy.text(definition.summaryKey ?? "", fallback: definition.id),
                    bucket: definition.bucket,
                    rarity: definition.rarity,
                    earnedFrom: "\(award.earnedFrom):\(localDate)",
                    status: "stored",
                    slot: definition.slot ?? "display"
                )
            )
        }
    }

    private func buildReminderPrompts() -> [ReminderPromptState] {
        var prompts: [ReminderPromptState] = []
        if let reminderVow = activeVows.first(where: { ($0.schedule.reminderLocalTime ?? "").isEmpty == false }) {
            prompts.append(
                ReminderPromptState(
                    id: "reminder",
                    title: "Next reminder",
                    body: "\(reminderVow.title) is set for \(reminderVow.schedule.reminderLocalTime ?? "later today")."
                )
            )
        }

        if completionDayCount > 0 {
            prompts.append(
                ReminderPromptState(
                    id: "witness",
                    title: "Witness prompt",
                    body: chapterState.tomorrowPrompt
                )
            )
        }

        if activeVows.contains(where: { $0.statusLabel == "Cooling" }) {
            prompts.append(
                ReminderPromptState(
                    id: "cooling",
                    title: "Cooling vow",
                    body: "A recent miss can still be rekindled if you return soon."
                )
            )
        }

        return prompts
    }

    private func currentSubscriptionSnapshot() -> LocalSubscriptionSnapshot {
        guard let record = try? repository.fetchSubscriptionState(),
              let snapshot = try? JSONDecoder().decode(LocalSubscriptionSnapshot.self, from: record.payload) else {
            return .free
        }
        return snapshot
    }

    private func visibleNPCIDs(for anchorID: String) -> [String] {
        districtState.visibleNPCIDs.filter { npcID in
            content.npcs.first(where: { $0.id == npcID })?.sceneAnchorId == anchorID
        }
    }

    private func advanceChainState(for vow: PlayableVow, localDate: String) -> (chainLength: Int, statusLabel: String) {
        guard let lastCompletedLocalDate = vow.lastCompletedLocalDate else {
            return (1, "Completed")
        }

        let dayGap = Self.dayDifference(from: lastCompletedLocalDate, to: localDate)
        if dayGap <= 1 {
            return (vow.chainLength + 1, "Completed")
        }

        if dayGap <= 3 && availableEmbers > 0 {
            availableEmbers -= 1
            return (vow.chainLength + 1, "Rekindled")
        }

        heat = max(0, heat - 1)
        return (1, "Cooling")
    }

    private func enqueueCompletionPayload(for vow: PlayableVow, localDate: String, progress: Int, isComplete: Bool, source: LocalCompletionSource) {
        let payload: [String: Any] = [
            "clientRequestId": "ios_\(UUID().uuidString)",
            "vowId": vow.id,
            "localDate": localDate,
            "source": source.apiValue,
            "progressState": isComplete ? "complete" : "partial",
            "quantity": vow.type == "count" ? progress : NSNull(),
            "durationMinutes": vow.type == "duration" ? progress : NSNull()
        ]

        if let data = try? JSONSerialization.data(withJSONObject: payload) {
            Task {
                await syncQueue.enqueue(SyncOperation(operationType: .completionSubmit, endpointPath: "v1/completions", payload: data))
                await syncStatusStore.refresh()
            }
        }
    }

    private func enqueueVerifiedCompletionPayload(
        vowID: String,
        sourceEventID: String,
        localDate: String,
        domain: HealthKitDomain,
        amount: Int
    ) {
        let payload: [String: Any] = [
            "sourceEventId": sourceEventID,
            "sourceType": "healthkit",
            "sourceDomain": domain.rawValue,
            "vowId": vowID,
            "localDate": localDate,
            "progressState": "complete",
            "quantity": domain == .steps ? amount : NSNull(),
            "durationMinutes": domain == .workout || domain == .sleep ? amount : NSNull()
        ]

        if let data = try? JSONSerialization.data(withJSONObject: payload) {
            Task {
                await syncQueue.enqueue(SyncOperation(operationType: .verifiedCompletion, endpointPath: "v1/verified-inputs/completions", payload: data))
                await syncStatusStore.refresh()
            }
        }
    }

    private func supportsVerifiedDomain(_ domain: HealthKitDomain, for vow: PlayableVow) -> Bool {
        switch domain {
        case .workout:
            return vow.type == "duration" && vow.category == "Physical"
        case .steps:
            return vow.type == "count" && vow.category == "Physical"
        case .sleep:
            return vow.type == "duration" && ["Rest", "Physical", "Emotional"].contains(vow.category)
        }
    }

    private func updateAvatarDefaults() {
        guard let identity = content.identityShells.first(where: { $0.id == selectedIdentityID }) else { return }
        avatarDraft.silhouetteId = identity.defaultAvatar?.silhouetteId ?? avatarDraft.silhouetteId
        avatarDraft.paletteId = identity.defaultAvatar?.paletteId ?? avatarDraft.paletteId
        avatarDraft.accessoryIds = identity.defaultAvatar?.accessoryIds ?? avatarDraft.accessoryIds
        if let family = content.originFamilies.first(where: { $0.id == identity.originFamilyId }) {
            selectedFamilyID = family.id
        }
    }

    func track(_ eventName: AnalyticsEventName, surface: String, properties: [String: String]) {
        Task {
            try? await analyticsClient.track(AnalyticsEvent(name: eventName, surface: surface, properties: properties))
        }
    }

    private static func playableVow(from template: LaunchContent.StarterVowTemplate, copy: CopyCatalog) -> PlayableVow {
        PlayableVow(
            id: template.id.replacingOccurrences(of: "vow_template_", with: "vow_"),
            title: copy.text(template.titleKey, fallback: template.titleKey),
            type: template.type,
            category: template.category,
            difficulty: template.difficulty,
            targetValue: template.targetValue,
            targetUnit: template.targetUnit,
            schedule: .init(
                cadence: template.schedule.cadence,
                activeWeekdays: template.schedule.activeWeekdays,
                reminderLocalTime: "08:00"
            ),
            progressToday: 0,
            isCompleteToday: false,
            chainLength: 0,
            bestChain: 0,
            statusLabel: "Ready",
            lastCompletedLocalDate: nil,
            history: []
        )
    }

    private static func chapterState(
        from content: LaunchContent,
        copy: CopyCatalog,
        completionDayCount: Int,
        subscription: LocalSubscriptionSnapshot
    ) -> ChapterCardState {
        let hasPremium = subscription.hasPremiumBreadth
        if completionDayCount <= content.starterArcDays.count {
            let chapter = content.chapters.first(where: { $0.id == "starter_arc" }) ?? content.chapters[0]
            let dayIndex = completionDayCount == 0 ? 0 : min(completionDayCount - 1, content.starterArcDays.count - 1)
            let day = content.starterArcDays[dayIndex]
            let quest = content.questTemplates.first(where: { $0.id == day.questId }) ?? content.questTemplates[0]

            return ChapterCardState(
                chapterID: "starter_arc",
                title: copy.text(chapter.titleKey, fallback: chapter.titleKey),
                summary: copy.text(quest.summaryKey, fallback: quest.summaryKey),
                currentDay: max(1, min(max(completionDayCount, 1), content.starterArcDays.count)),
                chapterLength: content.starterArcDays.count,
                progressPercent: min(Double(completionDayCount) / Double(max(content.starterArcDays.count, 1)), 1.0),
                tomorrowPrompt: copy.text(day.tomorrowPromptKey, fallback: day.tomorrowPromptKey),
                objectiveTitle: copy.text(quest.titleKey, fallback: quest.titleKey),
                statusNote: "",
                entitlementStatus: "free_preview"
            )
        }

        let chapter = content.chapters.first(where: { $0.id == "chapter_one" }) ?? content.chapters[0]
        guard let firstMilestone = content.chapterOneMilestones.first else {
            return ChapterCardState(
                chapterID: "chapter_one",
                title: copy.text(chapter.titleKey, fallback: chapter.titleKey),
                summary: copy.text(chapter.summaryKey, fallback: chapter.summaryKey),
                currentDay: 1,
                chapterLength: hasPremium ? 30 : 7,
                progressPercent: 0,
                tomorrowPrompt: copy.text(chapter.tomorrowCtaKey, fallback: chapter.tomorrowCtaKey),
                objectiveTitle: copy.text(chapter.titleKey, fallback: chapter.titleKey),
                statusNote: "",
                entitlementStatus: hasPremium ? "premium_full" : "free_preview"
            )
        }
        let rawDay = min(completionDayCount - content.starterArcDays.count, 30)
        let accessibleDay = hasPremium ? rawDay : min(rawDay, 7)
        let milestone = content.chapterOneMilestones.first(where: { accessibleDay >= $0.startDay && accessibleDay <= $0.endDay }) ?? firstMilestone
        let quest = content.questTemplates.first(where: { $0.id == milestone.questId }) ?? content.questTemplates[0]
        let statusNote = hasPremium
            ? (accessibleDay >= 30 ? copy.text("content.chapter.chapter_one.complete_note", fallback: "") : "")
            : copy.text("content.chapter.chapter_one.preview_note", fallback: "")

        return ChapterCardState(
            chapterID: "chapter_one",
            title: copy.text(chapter.titleKey, fallback: chapter.titleKey),
            summary: copy.text(quest.summaryKey, fallback: quest.summaryKey),
            currentDay: max(1, accessibleDay),
            chapterLength: hasPremium ? 30 : 7,
            progressPercent: min(Double(max(accessibleDay, 1)) / 30.0, 1.0),
            tomorrowPrompt: copy.text(milestone.tomorrowPromptKey, fallback: milestone.tomorrowPromptKey),
            objectiveTitle: copy.text(quest.titleKey, fallback: quest.titleKey),
            statusNote: statusNote,
            entitlementStatus: hasPremium ? "premium_full" : "free_preview"
        )
    }

    private static func districtState(
        from content: LaunchContent,
        copy: CopyCatalog,
        completionDayCount: Int,
        subscription: LocalSubscriptionSnapshot
    ) -> DistrictWitnessState {
        let district = content.districts.first(where: { $0.id == "ember_quay" }) ?? content.districts[0]
        let problemTitleKey: String
        let problemSummaryKey: String
        let stageID: String
        let visibleNPCIDs: [String]
        let momentID: String
        let problemProgress: Double

        if completionDayCount <= content.starterArcDays.count {
            switch completionDayCount {
            case 7...:
                stageID = "rekindled"
            case 3...:
                stageID = "rebuilding"
            case 1...:
                stageID = "stirring"
            default:
                stageID = district.startStageId
            }

            let day = content.starterArcDays[max(0, min(max(completionDayCount, 1) - 1, content.starterArcDays.count - 1))]
            visibleNPCIDs = day.npcIdsVisible
            momentID = day.worldMomentId
            problemTitleKey = "content.problem.starter_oven_crisis.title"
            problemSummaryKey = completionDayCount >= 7 ? "content.problem.starter_oven_crisis.resolution" : "content.problem.starter_oven_crisis.summary"
            problemProgress = min(Double(completionDayCount) / Double(max(content.starterArcDays.count, 1)), 1.0)
        } else {
            let rawDay = min(completionDayCount - content.starterArcDays.count, 30)
            let accessibleDay = subscription.hasPremiumBreadth ? rawDay : min(rawDay, 7)
            let milestone = content.chapterOneMilestones.first(where: { accessibleDay >= $0.startDay && accessibleDay <= $0.endDay }) ?? content.chapterOneMilestones.first ?? LaunchContent.ChapterOneMilestone(id: "fallback", startDay: 1, endDay: 30, questId: content.questTemplates.first?.id ?? "", restorationStageId: "market_waking", worldMomentId: content.magicalMoments.first?.id ?? "oven_glow", npcIdsVisible: [], tomorrowPromptKey: content.chapters.first?.tomorrowCtaKey ?? "")
            stageID = milestone.restorationStageId
            visibleNPCIDs = milestone.npcIdsVisible
            momentID = milestone.worldMomentId
            problemTitleKey = "content.problem.market_memory_crisis.title"
            problemSummaryKey = accessibleDay >= 30 ? "content.problem.market_memory_crisis.resolution" : "content.problem.market_memory_crisis.summary"
            problemProgress = min(Double(max(accessibleDay, 1)) / 30.0, 1.0)
        }

        let stage = district.restorationStages.first(where: { $0.id == stageID }) ?? district.restorationStages[0]
        let moment = content.magicalMoments.first(where: { $0.id == momentID }) ?? content.magicalMoments[0]

        return DistrictWitnessState(
            stageID: stageID,
            stageTitle: copy.text(stage.titleKey, fallback: stage.titleKey),
            moodText: copy.text(stage.sceneMoodKey, fallback: stage.sceneMoodKey),
            worldChangeText: copy.text(stage.worldChangeKey, fallback: stage.worldChangeKey),
            magicalMomentTitle: copy.text(moment.titleKey, fallback: moment.titleKey),
            magicalMomentBody: copy.text(moment.summaryKey, fallback: moment.summaryKey),
            visibleNPCIDs: visibleNPCIDs,
            problemTitle: copy.text(problemTitleKey, fallback: problemTitleKey),
            problemSummary: copy.text(problemSummaryKey, fallback: problemSummaryKey),
            problemProgressPercent: problemProgress
        )
    }

    private static func hearthState(from content: LaunchContent, copy: CopyCatalog, completionDayCount: Int, inventoryItems: [InventoryItemState]) -> HearthState {
        let props = inventoryItems.filter { ($0.bucket == "cosmetic" || $0.bucket == "prop" || $0.bucket == "chapter_reward") && $0.status == "applied" }.map(\.name)
        let summary: String
        switch completionDayCount {
        case 37...:
            summary = "Your Hearth now holds proof of a district that learned to gather again."
        case 14...:
            summary = "Chapter One rewards can now be placed here so your home keeps pace with the district."
        case 7...:
            summary = "The bakery hearth is warm again, and your earned props can now stay visible here."
        case 3...:
            summary = "The hearth is gathering small signs of repair as Ember Quay rebuilds."
        case 1...:
            summary = "A first proof of care has reached home."
        default:
            summary = "Your earned props and chapter keepsakes will gather here."
        }

        return HearthState(
            title: copy.text("hearth.headline", fallback: "Hearth"),
            summary: summary,
            unlockedPropNames: props,
            chapterClosureReady: completionDayCount >= 7
        )
    }

    private static func uniqueAvatarOptionIDs(_ ids: [String], fallback: String) -> [String] {
        var seen: Set<String> = []
        let options = ids.filter { seen.insert($0).inserted }
        if options.isEmpty {
            return [fallback]
        }
        return options
    }

    private static func readableAvatarLabel(_ identifier: String, prefix: String) -> String {
        identifier
            .replacingOccurrences(of: prefix, with: "")
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }

    private static func localDateString(now: Date = .now) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: now)
    }

    private static func dayDifference(from: String, to: String) -> Int {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        guard let fromDate = formatter.date(from: from),
              let toDate = formatter.date(from: to) else {
            return 0
        }
        return max(0, Calendar(identifier: .gregorian).dateComponents([.day], from: fromDate, to: toDate).day ?? 0)
    }

    private static func baseResonance(for type: String) -> Int {
        switch type {
        case "duration":
            return 12
        default:
            return 10
        }
    }

    private static func baseGold(for type: String) -> Int {
        switch type {
        case "duration":
            return 6
        default:
            return 5
        }
    }

    private static func difficultyMultiplier(for difficulty: String) -> Double {
        switch difficulty {
        case "gentle":
            return 0.8
        case "stretch":
            return 1.5
        default:
            return 1.0
        }
    }

    private static func rank(for lifetimeResonance: Int) -> Int {
        let thresholds = [0, 40, 100, 180, 280, 400, 540, 700, 880, 1080, 1300, 1540, 1800, 2080, 2380]
        var currentRank = 1
        for (index, threshold) in thresholds.enumerated() where lifetimeResonance >= threshold {
            currentRank = index + 1
        }
        return currentRank
    }
}
