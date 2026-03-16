import XCTest
@testable import Aevora

@MainActor
final class FirstPlayableStoreTests: XCTestCase {
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
}
