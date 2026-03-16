import XCTest
@testable import Aevora

final class AnalyticsTests: XCTestCase {
    func testValidatorRejectsUnknownEventNames() {
        let validator = AnalyticsValidator()
        let envelope = AnalyticsEnvelope(
            eventName: "unknown_event",
            eventVersion: "v1",
            occurredAtUTC: "2026-03-16T12:00:00Z",
            localDate: "2026-03-16",
            userID: nil,
            anonymousDeviceID: "device",
            sessionID: "session",
            surface: "today",
            appBuild: "1",
            platform: "ios",
            experimentAssignments: [],
            properties: [:]
        )

        XCTAssertThrowsError(try validator.validate(envelope))
    }

    func testClientQueuesValidatedEvents() async throws {
        let queue = SyncQueue()
        let client = AnalyticsClient(queue: queue, metadataProvider: AnalyticsMetadataProvider(), validator: AnalyticsValidator())
        try await client.track(AnalyticsEvent(name: .vowCompleted, surface: "today", properties: ["vow_id": "vow_1"]))
        let pendingCount = await queue.pendingCount()
        XCTAssertEqual(pendingCount, 1)
    }
}
