import XCTest
@testable import Aevora

@MainActor
final class DebugTests: XCTestCase {
    func testSeedScenarioLoaderProvidesFixtureReferences() {
        let scenarios = SeedScenarioLoader().loadScenarios()
        XCTAssertFalse(scenarios.isEmpty)
        XCTAssertTrue(scenarios[0].fixtureReferences.first?.contains("shared/contracts/fixtures/launch") ?? false)
    }

    func testFeatureFlagOverridesRoundTrip() {
        let store = FeatureFlagOverrideStore()
        store.set(true, for: .advancedWidgetsEnabled)
        XCTAssertEqual(store.value(for: .advancedWidgetsEnabled), true)
    }
}
