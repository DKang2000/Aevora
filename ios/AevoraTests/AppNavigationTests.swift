import XCTest
@testable import Aevora

@MainActor
final class AppNavigationTests: XCTestCase {
    func testTabShellBootsWithFourRootTabs() {
        XCTAssertEqual(AppTab.allCases.count, 4)
        XCTAssertEqual(AppTab.today.title, "Today")
    }

    func testEnvironmentCanSwitchTabs() {
        let environment = AppEnvironment(inMemory: true)
        XCTAssertEqual(environment.selectedTab, .today)
        environment.selectedTab = .world
        XCTAssertEqual(environment.selectedTab, .world)
    }
}
