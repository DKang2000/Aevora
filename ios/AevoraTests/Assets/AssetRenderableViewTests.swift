import XCTest
@testable import Aevora

@MainActor
final class AssetRenderableViewTests: XCTestCase {
    func testRenderSourceSelectsBundledResourceForImportedBundleArtifact() {
        let resolution = makeResolution(
            artifactPath: "bundle://aevora-v1-local-placeholder-manifest.seed.json",
            presentationState: .imported
        )

        let source = AevoraAssetRenderableView.renderSource(
            for: resolution,
            bundles: [Bundle.main, Bundle(for: AevoraAssetBundleMarker.self)]
        )

        switch source {
        case .localFile(let url):
            XCTAssertEqual(url.lastPathComponent, "aevora-v1-local-placeholder-manifest.seed.json")
        default:
            XCTFail("Expected a bundled local file source, got \(source)")
        }
    }

    func testRenderSourceSelectsRemoteURLForImportedRemoteArtifact() {
        let resolution = makeResolution(
            artifactPath: "https://cdn.example.com/imports/world-cyrane-tileset.png",
            presentationState: .imported
        )

        let source = AevoraAssetRenderableView.renderSource(for: resolution)

        switch source {
        case .remoteURL(let url):
            XCTAssertEqual(url.absoluteString, "https://cdn.example.com/imports/world-cyrane-tileset.png")
        default:
            XCTFail("Expected a remote render source, got \(source)")
        }
    }

    func testRenderSourceFallsBackForPlaceholderMappedAndMissingStates() {
        let mappedPlaceholder = makeResolution(
            artifactPath: "bundle://assets/art/placeholders/world-cyrane-tileset.png",
            presentationState: .mappedPlaceholder
        )
        let missing = makeResolution(
            artifactPath: nil,
            presentationState: .fallbackMissing
        )

        XCTAssertEqual(AevoraAssetRenderableView.renderSource(for: mappedPlaceholder), .placeholder)
        XCTAssertEqual(AevoraAssetRenderableView.renderSource(for: missing), .placeholder)
    }

    private func makeResolution(
        artifactPath: String?,
        presentationState: AevoraAssetResolution.PresentationState
    ) -> AevoraAssetResolution {
        let entry = artifactPath.map {
            AevoraAssetManifest.AssetEntry(
                assetId: AevoraAssetSlot.worldTilesetCyrane.rawValue,
                channel: .iosLaunch,
                logicalPath: "world/cyrane/tileset",
                artifactPath: $0,
                contentHash: presentationState == .mappedPlaceholder ? "seed-placeholder-world" : "imported-world",
                versionToken: presentationState == .mappedPlaceholder ? "seed-1" : "beta-import-1",
                contentType: "image/png",
                cacheControl: "no-store",
                sizeBytes: 0
            )
        }

        return AevoraAssetResolution(
            slot: .worldTilesetCyrane,
            family: AevoraAssetSlotFamily(
                id: AevoraAssetSlot.worldTilesetCyrane.rawValue,
                sectionId: "ART-11",
                betaCritical: true,
                surfaces: [.world]
            ),
            entry: entry,
            presentationState: presentationState,
            fallbackReason: "Test resolution"
        )
    }
}
