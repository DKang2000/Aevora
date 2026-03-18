import Foundation

final class AevoraAssetBundleMarker {}

struct AevoraAssetManifest: Codable, Equatable {
    struct AssetEntry: Codable, Equatable, Identifiable {
        let assetId: String
        let channel: Channel
        let logicalPath: String
        let artifactPath: String
        let contentHash: String
        let versionToken: String
        let contentType: String
        let cacheControl: String
        let sizeBytes: Int

        var id: String { assetId }
    }

    enum Channel: String, Codable, CaseIterable, Equatable {
        case iosLaunch = "ios_launch"
        case appStoreMetadata = "app_store_metadata"
        case worldScene = "world_scene"
        case widget
        case marketingPlaceholder = "marketing_placeholder"
    }

    let schemaVersion: String
    let releaseId: String
    let generatedAt: String
    let cdnBaseURL: String
    let assets: [AssetEntry]

    static func loadPlaceholderSeed() -> AevoraAssetManifest {
        for bundle in candidateBundles {
            if let url = bundle.url(forResource: "aevora-v1-local-placeholder-manifest.seed", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let manifest = try? JSONDecoder().decode(AevoraAssetManifest.self, from: data) {
                return manifest
            }
        }

        return fallbackManifest
    }

    func entry(for assetId: String) -> AssetEntry? {
        assets.first(where: { $0.assetId == assetId })
    }

    private static var candidateBundles: [Bundle] {
        var bundles: [Bundle] = [Bundle.main, Bundle(for: AevoraAssetBundleMarker.self)]
        if let allFrameworks = Bundle.allFrameworks.first {
            bundles.append(allFrameworks)
        }
        var seen = Set<ObjectIdentifier>()
        return bundles.filter { seen.insert(ObjectIdentifier($0)).inserted }
    }

    static let fallbackManifest = AevoraAssetManifest(
        schemaVersion: "v1",
        releaseId: "prebeta-placeholder-fallback",
        generatedAt: "2026-03-17T00:00:00Z",
        cdnBaseURL: "bundle://local-placeholders",
        assets: [
            .init(
                assetId: "onboarding.promise.card.family",
                channel: .iosLaunch,
                logicalPath: "onboarding/promise/cards",
                artifactPath: "bundle://assets/art/placeholders/onboarding-promise-card.png",
                contentHash: "seed-placeholder-onboarding-promise",
                versionToken: "seed-1",
                contentType: "image/png",
                cacheControl: "no-store",
                sizeBytes: 0
            ),
            .init(
                assetId: "avatar.base.bodyFrame.family",
                channel: .iosLaunch,
                logicalPath: "avatar/base/body-frame",
                artifactPath: "bundle://assets/art/placeholders/avatar-base-body-frame.png",
                contentHash: "seed-placeholder-avatar-body-frame",
                versionToken: "seed-1",
                contentType: "image/png",
                cacheControl: "no-store",
                sizeBytes: 0
            ),
            .init(
                assetId: "world.tileset.cyrane.family",
                channel: .worldScene,
                logicalPath: "world/cyrane/tileset",
                artifactPath: "bundle://assets/art/placeholders/world-cyrane-tileset.png",
                contentHash: "seed-placeholder-world-cyrane-tileset",
                versionToken: "seed-1",
                contentType: "image/png",
                cacheControl: "no-store",
                sizeBytes: 0
            ),
            .init(
                assetId: "hearth.environment.base.family",
                channel: .iosLaunch,
                logicalPath: "hearth/environment/base",
                artifactPath: "bundle://assets/art/placeholders/hearth-environment-base.png",
                contentHash: "seed-placeholder-hearth-environment-base",
                versionToken: "seed-1",
                contentType: "image/png",
                cacheControl: "no-store",
                sizeBytes: 0
            ),
            .init(
                assetId: "card.chapter.family",
                channel: .iosLaunch,
                logicalPath: "cards/chapter",
                artifactPath: "bundle://assets/art/placeholders/card-chapter-family.png",
                contentHash: "seed-placeholder-card-chapter",
                versionToken: "seed-1",
                contentType: "image/png",
                cacheControl: "no-store",
                sizeBytes: 0
            )
        ]
    )
}
