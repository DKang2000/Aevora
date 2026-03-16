import Foundation

actor SyncQueue {
    private var operations: [SyncOperation] = []

    func enqueue(_ operation: SyncOperation) {
        operations.append(operation)
    }

    func pendingOperations() -> [SyncOperation] {
        operations.sorted { $0.createdAt < $1.createdAt }
    }

    func markApplied(_ operationID: String) {
        operations.removeAll { $0.id == operationID }
    }

    func markRetryableFailure(_ operationID: String) {
        guard let index = operations.firstIndex(where: { $0.id == operationID }) else { return }
        operations[index].attemptCount += 1
        operations[index].status = .retryableError
    }

    func pendingCount() -> Int {
        operations.count
    }
}
