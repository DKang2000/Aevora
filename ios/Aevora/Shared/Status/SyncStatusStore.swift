import Foundation

enum SyncBannerState: Equatable {
    case hidden
    case offline
    case syncing(count: Int)
    case conflict
}

@MainActor
final class SyncStatusStore: ObservableObject {
    @Published private(set) var bannerState: SyncBannerState = .hidden

    private let connectivityMonitor: ConnectivityMonitor
    private let syncQueue: SyncQueue

    init(connectivityMonitor: ConnectivityMonitor, syncQueue: SyncQueue) {
        self.connectivityMonitor = connectivityMonitor
        self.syncQueue = syncQueue
    }

    func refresh(hasConflict: Bool = false) async {
        let pendingCount = await syncQueue.pendingCount()
        if hasConflict {
            bannerState = .conflict
        } else if !connectivityMonitor.isOnline {
            bannerState = .offline
        } else if pendingCount > 0 {
            bannerState = .syncing(count: pendingCount)
        } else {
            bannerState = .hidden
        }
    }
}
