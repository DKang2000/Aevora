import XCTest
@testable import Aevora

@MainActor
final class AssetRuntimeTests: XCTestCase {
    func testPlaceholderManifestLoadsExpectedLaunchEntries() {
        let manifest = AevoraAssetManifest.loadPlaceholderSeed()

        XCTAssertEqual(manifest.schemaVersion, "v1")
        XCTAssertNotNil(manifest.entry(for: AevoraAssetSlot.onboardingPromiseCards.rawValue))
        XCTAssertNotNil(manifest.entry(for: AevoraAssetSlot.worldTilesetCyrane.rawValue))
        XCTAssertNotNil(manifest.entry(for: AevoraAssetSlot.hearthEnvironmentBase.rawValue))
    }

    func testRegistryExposesSeedFamiliesAndBetaCriticalFlags() {
        let registry = AevoraAssetRegistry.load()

        XCTAssertEqual(registry.allSlots.count, 49)
        XCTAssertEqual(registry.family(for: .onboardingPromiseCards)?.sectionId, "ART-05")
        XCTAssertEqual(registry.family(for: .rewardCard)?.sectionId, "ART-19")
        XCTAssertTrue(registry.family(for: .npcBust)?.betaCritical ?? false)
        XCTAssertFalse(registry.family(for: .rewardFX)?.betaCritical ?? true)
    }

    func testResolverTracksMissingBetaCriticalSlotsWithoutThrowing() {
        let manifest = AevoraAssetManifest(
            schemaVersion: "v1",
            releaseId: "test-placeholder",
            generatedAt: "2026-03-17T00:00:00Z",
            cdnBaseURL: "bundle://local-placeholders",
            assets: [
                .init(
                    assetId: AevoraAssetSlot.onboardingPromiseCards.rawValue,
                    channel: .iosLaunch,
                    logicalPath: "onboarding/promise/cards",
                    artifactPath: "bundle://placeholder.png",
                    contentHash: "hash",
                    versionToken: "v1",
                    contentType: "image/png",
                    cacheControl: "no-store",
                    sizeBytes: 0
                )
            ]
        )
        let resolver = AevoraAssetResolver(registry: AevoraAssetRegistry.load(), manifest: manifest)

        let mapped = resolver.resolve(.onboardingPromiseCards)
        let missing = resolver.resolve(.npcBust)

        XCTAssertTrue(mapped.isMapped)
        XCTAssertEqual(missing.status, .placeholderFallback)
        XCTAssertTrue(missing.isBetaCriticalMissing)
        XCTAssertTrue(resolver.missingBetaCriticalSlotIDs.contains(AevoraAssetSlot.npcBust.rawValue))
    }

    func testDebugEntriesExposeLogicalPathAndStatus() {
        let resolver = AevoraAssetResolver(
            registry: AevoraAssetRegistry.load(),
            manifest: AevoraAssetManifest.loadPlaceholderSeed()
        )

        let entries = resolver.debugEntries(surface: .world)

        XCTAssertFalse(entries.isEmpty)
        XCTAssertTrue(entries.contains(where: { $0.slot == .worldTilesetCyrane }))
        XCTAssertTrue(entries.allSatisfy { !$0.resolution.logicalPath.isEmpty })
    }
}
