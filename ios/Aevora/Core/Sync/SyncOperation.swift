import Foundation

enum SyncOperationType: String, Codable {
    case vowCreate = "vow_create"
    case vowUpdate = "vow_update"
    case vowArchive = "vow_archive"
    case completionSubmit = "completion_submit"
    case shopPurchase = "shop_purchase"
    case verifiedCompletion = "verified_completion"
    case analyticsEvent = "analytics_event"
}

enum SyncOperationStatus: String, Codable {
    case pending
    case inFlight = "in_flight"
    case retryableError = "retryable_error"
    case terminalError = "terminal_error"
    case applied
}

struct SyncOperation: Identifiable, Codable, Equatable {
    let id: String
    let operationType: SyncOperationType
    let endpointPath: String
    let payload: Data
    var attemptCount: Int
    var status: SyncOperationStatus
    var dependencyIDs: [String]
    let createdAt: Date

    init(
        id: String = UUID().uuidString,
        operationType: SyncOperationType,
        endpointPath: String,
        payload: Data,
        attemptCount: Int = 0,
        status: SyncOperationStatus = .pending,
        dependencyIDs: [String] = [],
        createdAt: Date = .now
    ) {
        self.id = id
        self.operationType = operationType
        self.endpointPath = endpointPath
        self.payload = payload
        self.attemptCount = attemptCount
        self.status = status
        self.dependencyIDs = dependencyIDs
        self.createdAt = createdAt
    }
}
