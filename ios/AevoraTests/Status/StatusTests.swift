import XCTest
@testable import Aevora

@MainActor
final class StatusTests: XCTestCase {
    func testOfflineBannerVisibility() async {
        let monitor = ConnectivityMonitor()
        let queue = SyncQueue()
        let store = SyncStatusStore(connectivityMonitor: monitor, syncQueue: queue)
        monitor.setOnline(false)
        await store.refresh()
        XCTAssertEqual(store.bannerState, .offline)
    }

    func testSyncingBannerShowsQueueCount() async {
        let monitor = ConnectivityMonitor()
        let queue = SyncQueue()
        await queue.enqueue(SyncOperation(operationType: .vowCreate, endpointPath: "v1/vows", payload: Data()))
        let store = SyncStatusStore(connectivityMonitor: monitor, syncQueue: queue)
        await store.refresh()
        XCTAssertEqual(store.bannerState, .syncing(count: 1))
    }
}
