import XCTest
@testable import Aevora

@MainActor
final class ObservabilityTests: XCTestCase {
    func testRedactionPolicyRemovesSensitiveMetadata() {
        let sanitized = RedactionPolicy().sanitize([
            "user_id": "usr_1",
            "note_text": "hello",
            "surface": "today"
        ])

        XCTAssertEqual(sanitized["user_id"], "<redacted>")
        XCTAssertNil(sanitized["note_text"])
        XCTAssertEqual(sanitized["surface"], "today")
    }

    func testStructuredLoggerStoresSanitizedEntries() {
        let logger = StructuredLogger()
        logger.info("Logged", context: LogContext(category: "sync", requestID: "req_1"), metadata: ["user_id": "usr_1"])
        XCTAssertEqual(logger.entries.first?.metadata["user_id"], "<redacted>")
    }
}
