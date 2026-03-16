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

    func testNotificationDeepLinkCanOpenWorldAndQuestJournal() {
        let environment = AppEnvironment(inMemory: true)

        environment.handleOpenURL(AppDeepLink.url(source: .notification, destination: .world))
        XCTAssertEqual(environment.selectedTab, .world)

        environment.handleOpenURL(AppDeepLink.url(source: .notification, destination: .questJournal))
        XCTAssertEqual(environment.selectedTab, .today)
        XCTAssertTrue(environment.firstPlayableStore.isQuestJournalPresented)
    }
}
