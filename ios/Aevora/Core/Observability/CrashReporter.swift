import Foundation

@MainActor
protocol CrashReporter {
    func record(_ error: Error, context: LogContext)
}

@MainActor
final class DevelopmentCrashReporter: CrashReporter {
    private let logger: StructuredLogger

    init(logger: StructuredLogger) {
        self.logger = logger
    }

    func record(_ error: Error, context: LogContext) {
        logger.info("Captured error: \(error.localizedDescription)", context: context)
    }
}
