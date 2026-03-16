import XCTest
@testable import Aevora

@MainActor
final class RemoteConfigClientTests: XCTestCase {
    func testLoadsDefaultsAndResolvesFlags() throws {
        let client = RemoteConfigClient(defaultsLoader: {
            Data("""
            {"schemaVersion":"v1","featureFlags":{"advanced_widgets_enabled":true},"economy":{},"onboarding":{},"paywall":{},"reminders":{},"widgets":{"basicWidgetEnabled":true,"advancedWidgetRefreshMinutes":30},"liveActivities":{},"chapterGating":{}}
            """.utf8)
        }, overrideProvider: { _ in nil })

        let config = try client.loadDefaults()
        XCTAssertEqual(config.schemaVersion, "v1")
        XCTAssertTrue(try client.featureFlag(.advancedWidgetsEnabled))
    }

    func testRejectsInvalidConfig() {
        let client = RemoteConfigClient(defaultsLoader: { Data("{\"schemaVersion\":\"v1\"}".utf8) }, overrideProvider: { _ in nil })
        XCTAssertThrowsError(try client.loadDefaults())
    }
}
