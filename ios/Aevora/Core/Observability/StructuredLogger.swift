import Foundation

struct LogEntry: Equatable {
    let level: String
    let message: String
    let context: LogContext
    let metadata: [String: String]
}

@MainActor
final class StructuredLogger: ObservableObject {
    @Published private(set) var entries: [LogEntry] = []
    private let redactionPolicy = RedactionPolicy()

    func info(_ message: String, context: LogContext, metadata: [String: String] = [:]) {
        let entry = LogEntry(level: "info", message: message, context: context, metadata: redactionPolicy.sanitize(metadata))
        entries.insert(entry, at: 0)
    }
}
