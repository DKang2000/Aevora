import XCTest
@testable import Aevora

@MainActor
final class AssetSurfaceContractTests: XCTestCase {
    func testOnboardingLateArtStepsResolveThroughLogicalSlots() {
        let environment = AppEnvironment(inMemory: true)

        let slots = [
            OnboardingFlowStep.welcomePromise,
            .problemSolution,
            .family,
            .identity,
            .avatar,
            .magicalMoment,
            .softPaywall
        ]
        .compactMap(OnboardingRootView.assetSlot(for:))
        let resolutions = environment.assetResolver.resolve(slots: slots)

        XCTAssertEqual(resolutions.count, slots.count)
        XCTAssertTrue(resolutions.allSatisfy { !$0.logicalPath.isEmpty })
    }

    func testTodayRewardWorldAndHearthSurfacesHavePlaceholderSafeAssetHooks() {
        let environment = AppEnvironment(inMemory: true)
        let resolver = environment.assetResolver

        let surfaceSlots =
            TodayRootView.chapterAssetSlots +
            RewardModalView.assetSlots +
            WorldRootView.sceneAssetSlots +
            WorldRootView.districtAssetSlots +
            WorldRootView.npcAssetSlots +
            WorldRootView.shopAssetSlots +
            HearthRootView.heroAssetSlots

        let resolutions = resolver.resolve(slots: surfaceSlots)

        XCTAssertEqual(resolutions.count, surfaceSlots.count)
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .chapterCard }))
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .worldTilesetCyrane }))
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .hearthEnvironmentBase }))
    }

    func testMajorBridgeSurfacesResolveLogicalSlotsEndToEnd() {
        let environment = AppEnvironment(inMemory: true)
        let resolver = environment.assetResolver

        let slots =
            OnboardingFlowStep.allCases.compactMap(OnboardingRootView.assetSlot(for:)) +
            TodayRootView.chapterAssetSlots +
            RewardModalView.assetSlots +
            WorldRootView.sceneAssetSlots +
            WorldRootView.districtAssetSlots +
            WorldRootView.npcAssetSlots +
            WorldRootView.shopAssetSlots +
            HearthRootView.heroAssetSlots

        let resolutions = resolver.resolve(slots: slots)

        XCTAssertEqual(resolutions.count, slots.count)
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .onboardingPaywallSupporting }))
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .rewardCard }))
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .npcBust }))
        XCTAssertTrue(resolutions.contains(where: { $0.slot == .shopCardArt }))
        XCTAssertTrue(resolutions.allSatisfy { !$0.logicalPath.isEmpty })
    }

    func testInventoryBucketsRouteToExpectedAssetFamilies() {
        let propItem = InventoryItemState(
            id: "prop-1",
            itemDefinitionId: "ember_quay_token",
            name: "Lantern Rack",
            summary: "Visible progress for your Hearth.",
            bucket: "prop",
            rarity: "uncommon",
            earnedFrom: "starter",
            status: "stored",
            slot: "display"
        )
        let cosmeticItem = InventoryItemState(
            id: "cosmetic-1",
            itemDefinitionId: "archive_map_cosmetic",
            name: "Archive Map",
            summary: "A cosmetic keepsake.",
            bucket: "cosmetic",
            rarity: "rare",
            earnedFrom: "starter",
            status: "stored",
            slot: "display"
        )

        XCTAssertEqual(HearthRootView.slot(for: propItem), .itemIcon)
        XCTAssertEqual(HearthRootView.slot(for: cosmeticItem), .cosmeticIcon)
    }
}
