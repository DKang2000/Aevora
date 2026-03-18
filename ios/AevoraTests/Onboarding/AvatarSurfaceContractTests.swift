import XCTest
@testable import Aevora

@MainActor
final class AvatarSurfaceContractTests: XCTestCase {
    func testAvatarPresentationCatalogResolvesDefaultSeedIDs() {
        XCTAssertNotNil(AvatarPresentationCatalog.silhouette(for: "silhouette_oven_apron"))
        XCTAssertNotNil(AvatarPresentationCatalog.palette(for: "palette_ember_ochre"))
        XCTAssertNotNil(AvatarPresentationCatalog.accessory(for: "accessory_flour_wrap"))
    }

    func testOnboardingAvatarStepUsesFamilyScopedLaunchOptions() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        let avatarState = OnboardingRootView.avatarStepState(for: store)

        XCTAssertEqual(avatarState.configuration.silhouetteId, "silhouette_oven_apron")
        XCTAssertEqual(avatarState.configuration.paletteId, "palette_ember_ochre")
        XCTAssertEqual(avatarState.configuration.accessoryLabel, "Flour Wrap")
        XCTAssertEqual(
            avatarState.silhouetteOptions.map(\.id),
            ["silhouette_field_apron", "silhouette_oven_apron", "silhouette_counter_vest"]
        )
        XCTAssertEqual(
            avatarState.paletteOptions.map(\.id),
            ["palette_harvest_green", "palette_ember_ochre", "palette_roasted_clay"]
        )
    }

    func testHearthHeroConfigurationIncludesAvatarAndIdentityContext() {
        let environment = AppEnvironment(inMemory: true)
        let store = environment.firstPlayableStore

        let heroConfiguration = HearthRootView.heroConfiguration(for: store)

        XCTAssertEqual(heroConfiguration.displayName, "Wayfarer")
        XCTAssertEqual(heroConfiguration.identityName, store.selectedIdentityDisplayName)
        XCTAssertEqual(heroConfiguration.accessoryLabel, "Flour Wrap")
        XCTAssertEqual(heroConfiguration.silhouetteId, store.avatarDraft.silhouetteId)
        XCTAssertEqual(heroConfiguration.paletteId, store.avatarDraft.paletteId)
        XCTAssertFalse(heroConfiguration.statusLine.isEmpty)
    }
}
