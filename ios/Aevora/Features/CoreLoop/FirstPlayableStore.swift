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
    var title: String
    var summary: String
    var currentDay: Int
    var progressPercent: Double
    var tomorrowPrompt: String
    var objectiveTitle: String
}

struct DistrictWitnessState: Equatable, Codable {
    var stageID: String
    var stageTitle: String
    var moodText: String
    var worldChangeText: String
    var magicalMomentTitle: String
    var magicalMomentBody: String
    var visibleNPCIDs: [String]
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
    let bucket: String
    let rarity: String
    let earnedFrom: String
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

        let initialChapter = Self.chapterState(from: self.content, copy: copy, completionDayCount: 0)
        let initialDistrict = Self.districtState(from: self.content, copy: copy, completionDayCount: 0)
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
        if onboardingStep == 3 {
            updateAvatarDefaults()
            track(.originFamilySelected, surface: "onboarding", properties: ["family_id": selectedFamilyID])
        }

        if onboardingStep == 4 {
            updateAvatarDefaults()
            track(.identitySelected, surface: "onboarding", properties: ["identity_id": selectedIdentityID])
        }

        if onboardingStep == 5 {
            generateStarterRecommendations()
            track(.avatarCreated, surface: "onboarding", properties: ["silhouette_id": avatarDraft.silhouetteId])
        }

        onboardingStep = min(onboardingStep + 1, 6)
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
        recordCompletion(vowID: vowID, amount: amount, localDate: Self.localDateString())
    }

    func recordCompletion(vowID: String, amount: Int, localDate: String) {
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

        enqueueCompletionPayload(for: vow, localDate: localDate, progress: progress, isComplete: isComplete)
        persistSnapshot()
        track(.vowCompleted, surface: "today", properties: ["vow_id": vow.id, "progress_percent": "\(progressPercent)"])
        track(.resonanceAwarded, surface: "reward", properties: ["amount": "\(resonance)"])
        track(.goldAwarded, surface: "reward", properties: ["amount": "\(gold)"])
        if wasFirstCompletionForDay {
            track(.dayCompletedFirstVow, surface: "today", properties: ["local_date": localDate])
            track(.firstMagicalMomentViewed, surface: "reward", properties: ["moment_id": content.starterArcDays.first?.worldMomentId ?? "oven_glow"])
            track(.districtProgressed, surface: "world", properties: ["district_id": "ember_quay", "stage_id": districtState.stageID])
        }
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

    func itemName(for itemDefinitionID: String) -> String {
        guard let item = content.itemDefinitions.first(where: { $0.id == itemDefinitionID }) else {
            return itemDefinitionID
        }
        return copy.text(item.nameKey, fallback: itemDefinitionID)
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
            inventoryItems: inventoryItems
        )

        if let data = try? JSONEncoder().encode(snapshot) {
            try? repository.saveCoreLoopSnapshot(payload: data)
        }
        onStateChanged?(self)
    }

    private func refreshDerivedState() {
        chapterState = Self.chapterState(from: content, copy: copy, completionDayCount: completionDayCount)
        districtState = Self.districtState(from: content, copy: copy, completionDayCount: completionDayCount)
        hearthState = Self.hearthState(from: content, copy: copy, completionDayCount: completionDayCount, inventoryItems: inventoryItems)
        reminderPrompts = buildReminderPrompts()
    }

    private func unlockInventoryIfNeeded() {
        let awardDefinitions: [(requiredDay: Int, itemID: String, earnedFrom: String)] = [
            (1, "ember_quay_token", "starter_day_1_reward"),
            (7, "hearth_apron_common", "starter_day_7_chest")
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
                    bucket: definition.bucket,
                    rarity: definition.rarity,
                    earnedFrom: "\(award.earnedFrom):\(localDate)"
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

        if completionDayCount > 0 && completionDayCount < 7 {
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

    private func enqueueCompletionPayload(for vow: PlayableVow, localDate: String, progress: Int, isComplete: Bool) {
        let payload: [String: Any] = [
            "clientRequestId": "ios_\(UUID().uuidString)",
            "vowId": vow.id,
            "localDate": localDate,
            "source": "manual",
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

    private func updateAvatarDefaults() {
        guard let identity = content.identityShells.first(where: { $0.id == selectedIdentityID }) else { return }
        avatarDraft.silhouetteId = identity.defaultAvatar?.silhouetteId ?? avatarDraft.silhouetteId
        avatarDraft.paletteId = identity.defaultAvatar?.paletteId ?? avatarDraft.paletteId
        avatarDraft.accessoryIds = identity.defaultAvatar?.accessoryIds ?? avatarDraft.accessoryIds
        if let family = content.originFamilies.first(where: { $0.id == identity.originFamilyId }) {
            selectedFamilyID = family.id
        }
    }

    private func track(_ eventName: AnalyticsEventName, surface: String, properties: [String: String]) {
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

    private static func chapterState(from content: LaunchContent, copy: CopyCatalog, completionDayCount: Int) -> ChapterCardState {
        let chapter = content.chapters.first(where: { $0.id == "starter_arc" }) ?? content.chapters[0]
        let dayIndex = completionDayCount == 0 ? 0 : min(completionDayCount - 1, content.starterArcDays.count - 1)
        let day = content.starterArcDays[dayIndex]
        let quest = content.questTemplates.first(where: { $0.id == day.questId }) ?? content.questTemplates[0]

        return ChapterCardState(
            title: copy.text(chapter.titleKey, fallback: chapter.titleKey),
            summary: copy.text(quest.summaryKey, fallback: quest.summaryKey),
            currentDay: max(1, min(max(completionDayCount, 1), 7)),
            progressPercent: min(Double(completionDayCount) / 7.0, 1.0),
            tomorrowPrompt: copy.text(day.tomorrowPromptKey, fallback: day.tomorrowPromptKey),
            objectiveTitle: copy.text(quest.titleKey, fallback: quest.titleKey)
        )
    }

    private static func districtState(from content: LaunchContent, copy: CopyCatalog, completionDayCount: Int) -> DistrictWitnessState {
        let district = content.districts.first(where: { $0.id == "ember_quay" }) ?? content.districts[0]
        let stageID: String
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

        let stage = district.restorationStages.first(where: { $0.id == stageID }) ?? district.restorationStages[0]
        let day = content.starterArcDays[max(0, min(max(completionDayCount, 1) - 1, content.starterArcDays.count - 1))]
        let moment = content.magicalMoments.first(where: { $0.id == day.worldMomentId }) ?? content.magicalMoments[0]

        return DistrictWitnessState(
            stageID: stageID,
            stageTitle: copy.text(stage.titleKey, fallback: stage.titleKey),
            moodText: copy.text(stage.sceneMoodKey, fallback: stage.sceneMoodKey),
            worldChangeText: copy.text(stage.worldChangeKey, fallback: stage.worldChangeKey),
            magicalMomentTitle: copy.text(moment.titleKey, fallback: moment.titleKey),
            magicalMomentBody: copy.text(moment.summaryKey, fallback: moment.summaryKey),
            visibleNPCIDs: day.npcIdsVisible
        )
    }

    private static func hearthState(from content: LaunchContent, copy: CopyCatalog, completionDayCount: Int, inventoryItems: [InventoryItemState]) -> HearthState {
        let props = inventoryItems.filter { $0.bucket == "cosmetic" || $0.bucket == "prop" }.map(\.name)
        let summary: String
        switch completionDayCount {
        case 7...:
            summary = "The bakery hearth is warm again, and your earned props now live here."
        case 3...:
            summary = "The hearth is gathering small signs of repair as Ember Quay rebuilds."
        case 1...:
            summary = "A first proof of care has reached home."
        default:
            summary = "Your earned props and chapter keepsakes will gather here."
        }

        return HearthState(
            title: "Hearth",
            summary: summary,
            unlockedPropNames: props,
            chapterClosureReady: completionDayCount >= 7
        )
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
