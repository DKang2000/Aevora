import Foundation

struct LogContext: Equatable {
    var category: String
    var requestID: String?
    var syncOperationID: String?
}
