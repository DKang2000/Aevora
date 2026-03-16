import XCTest
@testable import Aevora

@MainActor
final class PersistenceTests: XCTestCase {
    func testSaveAndLoadVows() throws {
        let controller = PersistenceController(inMemory: true)
        let repository = SwiftDataRepository(modelContext: controller.mainContext)
        try repository.saveVow(LocalVowRecord(id: "vow_1", title: "Read", type: "binary", lifecycle: "active"))

        let vows = try repository.fetchVows()
        XCTAssertEqual(vows.map(\.id), ["vow_1"])
    }

    func testRemoteConfigRoundTrip() throws {
        let controller = PersistenceController(inMemory: true)
        let repository = SwiftDataRepository(modelContext: controller.mainContext)
        try repository.saveRemoteConfig(payload: Data("{}".utf8), schemaVersion: "v1")

        let cache = try repository.fetchRemoteConfigCache()
        XCTAssertEqual(cache?.schemaVersion, "v1")
    }
}
