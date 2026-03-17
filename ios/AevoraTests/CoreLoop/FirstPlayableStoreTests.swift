import XCTest
@testable import Aevora

@MainActor
final class FirstPlayableStoreTests: XCTestCase {
    func testLockedOnboardingSequenceReachesSoftPaywallAfterGuestChoice() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        XCTAssertEqual(store.currentOnboardingFlowStep, .welcomePromise)
        XCTAssertEqual(store.onboardingProgressTotal, 15)

        store.advanceOnboarding()
        XCTAssertEqual(store.currentOnboardingFlowStep, .problemSolution)

        store.advanceOnboarding()
        XCTAssertEqual(store.currentOnboardingFlowStep, .signIn)

        store.advanceOnboarding()
        XCTAssertEqual(store.currentOnboardingFlowStep, .signIn, "Auth choice should remain required before advancing past sign-in.")

        store.beginGuestMode()
        store.advanceOnboarding()
        XCTAssertEqual(store.currentOnboardingFlowStep, .goals)

        while store.currentOnboardingFlowStep != .softPaywall {
            store.advanceOnboarding()
        }

        XCTAssertEqual(store.currentOnboardingFlowStep, .softPaywall)
        XCTAssertFalse(store.recommendedVows.isEmpty)
    }

    func testFinishingOnboardingSuppressesRepeatSoftPaywallAfterFirstReward() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        store.beginGuestMode()
        store.generateStarterRecommendations()
        store.finishOnboarding()

        guard let firstVow = store.activeVows.first else {
            XCTFail("Expected starter vows")
            return
        }

        store.quickLog(firstVow)
        if store.isProgressSheetPresented {
            store.confirmProgressSheet()
        }

        XCTAssertNotNil(store.rewardPresentation)
        store.rewardDismissed()
        XCTAssertFalse(store.isSoftPaywallPresented, "Onboarding paywall preview should prevent an immediate second paywall after the first reward.")
    }

    func testStarterRecommendationsRespectFreePathLimit() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        store.beginGuestMode()
        store.selectedLifeAreas = ["Physical", "Career", "Emotional"]
        store.selectedBlocker = "I forget"
        store.dailyLoad = 7
        store.toneMode = "balanced"
        store.generateStarterRecommendations()

        XCTAssertGreaterThanOrEqual(store.recommendedVows.count, 1)
        XCTAssertLessThanOrEqual(store.recommendedVows.count, 3)
    }

    func testFirstCompletionAdvancesRewardAndDistrictState() async {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        store.beginGuestMode()
        store.generateStarterRecommendations()
        store.finishOnboarding()

        guard let firstVow = store.activeVows.first else {
            XCTFail("Expected starter vows")
            return
        }

        store.quickLog(firstVow)
        if store.isProgressSheetPresented {
            store.confirmProgressSheet()
        }

        XCTAssertNotNil(store.rewardPresentation)
        XCTAssertEqual(store.districtState.stageID, "stirring")
        XCTAssertEqual(store.chapterState.currentDay, 1)

        try? await Task.sleep(nanoseconds: 100_000_000)
        let pendingCount = await environment.syncQueue.pendingCount()
        XCTAssertGreaterThan(pendingCount, 0)
        XCTAssertEqual(store.inventoryItems.first?.itemDefinitionId, "ember_quay_token")
    }

    func testDurableSnapshotCarriesStarterArcProgressAcrossStoreRebuild() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        store.beginGuestMode()
        store.generateStarterRecommendations()
        store.finishOnboarding()

        guard let firstVow = store.activeVows.first else {
            XCTFail("Expected starter vows")
            return
        }

        store.recordCompletion(vowID: firstVow.id, amount: firstVow.targetValue, localDate: "2026-03-16")
        store.recordCompletion(vowID: firstVow.id, amount: firstVow.targetValue, localDate: "2026-03-17")
        store.recordCompletion(vowID: firstVow.id, amount: firstVow.targetValue, localDate: "2026-03-20")

        let rebuilt = FirstPlayableStore(
            repository: environment.repository,
            syncQueue: environment.syncQueue,
            analyticsClient: environment.analyticsClient,
            syncStatusStore: environment.syncStatusStore
        )

        XCTAssertEqual(rebuilt.completionDayCount, 3)
        XCTAssertEqual(rebuilt.districtState.stageID, "rebuilding")
        XCTAssertEqual(rebuilt.inventoryItems.first?.itemDefinitionId, "ember_quay_token")
        XCTAssertEqual(rebuilt.availableEmbers, 1)
    }

    func testChapterOnePreviewAndShopPurchaseBehaviors() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        store.beginGuestMode()
        store.generateStarterRecommendations()
        store.finishOnboarding()

        guard let firstVow = store.activeVows.first else {
            XCTFail("Expected starter vows")
            return
        }

        for (index, date) in [
            "2026-03-16", "2026-03-17", "2026-03-18", "2026-03-19", "2026-03-20", "2026-03-21", "2026-03-22",
            "2026-03-23", "2026-03-24", "2026-03-25", "2026-03-26", "2026-03-27", "2026-03-28", "2026-03-29"
        ].enumerated() {
            store.recordCompletion(vowID: firstVow.id, amount: firstVow.targetValue, localDate: date)
            XCTAssertGreaterThanOrEqual(store.rewardPresentation?.gold ?? 0, 0, "Reward presentation missing at index \(index)")
        }

        XCTAssertEqual(store.chapterState.chapterID, "chapter_one")
        XCTAssertEqual(store.chapterState.currentDay, 7)
        XCTAssertFalse(store.availableShopOffers.isEmpty)

        let startingGold = store.goldBalance
        guard let firstOffer = store.availableShopOffers.first(where: { !$0.isLocked && $0.canAfford }) else {
            XCTFail("Expected at least one available offer")
            return
        }

        store.purchaseOffer(firstOffer.id)

        XCTAssertLessThan(store.goldBalance, startingGold)
        XCTAssertTrue(store.inventoryItems.contains(where: { $0.itemDefinitionId == firstOffer.itemDefinitionId }))

        guard let purchasedItem = store.inventoryItems.first(where: { $0.itemDefinitionId == firstOffer.itemDefinitionId }) else {
            XCTFail("Expected purchased item in inventory")
            return
        }

        store.toggleItemApplied(purchasedItem.id)
        XCTAssertTrue(store.hearthState.unlockedPropNames.contains(where: { $0 == purchasedItem.name }))
    }

    func testVerifiedCompletionImportDoesNotDuplicateLocalCompletion() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        store.beginGuestMode()
        store.selectedLifeAreas = ["Physical"]
        store.generateStarterRecommendations()
        store.finishOnboarding()

        guard let vowID = store.matchingVerifiedVowID(for: .workout),
              let vow = store.activeVows.first(where: { $0.id == vowID }) else {
            XCTFail("Expected a workout-eligible vow")
            return
        }

        let localDate = DateFormatter.aevoraTestLocalDate.string(from: .now)
        store.recordCompletion(vowID: vow.id, amount: vow.targetValue, localDate: localDate)
        let startingGold = store.goldBalance

        store.recordVerifiedCompletion(vowID: vow.id, sourceEventID: "hk_evt_duplicate", localDate: localDate, domain: .workout, amount: vow.targetValue)
        store.recordVerifiedCompletion(vowID: vow.id, sourceEventID: "hk_evt_duplicate", localDate: localDate, domain: .workout, amount: vow.targetValue)

        XCTAssertEqual(store.goldBalance, startingGold)
        XCTAssertEqual(store.completionBadge(for: vow.id), "Verified")
    }
}
