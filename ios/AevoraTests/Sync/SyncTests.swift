import XCTest
@testable import Aevora

private struct EmptyTransport: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (Data("{}".utf8), response)
    }
}

final class SyncTests: XCTestCase {
    func testQueuePreservesReplayOrder() async {
        let queue = SyncQueue()
        await queue.enqueue(SyncOperation(operationType: .vowCreate, endpointPath: "a", payload: Data()))
        await queue.enqueue(SyncOperation(operationType: .vowUpdate, endpointPath: "b", payload: Data()))
        let operations = await queue.pendingOperations()
        XCTAssertEqual(operations.map(\.endpointPath), ["a", "b"])
    }

    func testFlushAppliesOperationsWhenOnline() async {
        let queue = SyncQueue()
        await queue.enqueue(SyncOperation(operationType: .analyticsEvent, endpointPath: "v1/analytics/events", payload: Data("{}".utf8)))
        let coordinator = SyncCoordinator(
            apiClient: APIClient(baseURL: URL(string: "https://example.com")!, transport: EmptyTransport()),
            queue: queue,
            isNetworkAvailable: { true }
        )

        await coordinator.flush()
        let pendingCount = await queue.pendingCount()
        XCTAssertEqual(pendingCount, 0)
    }
}
