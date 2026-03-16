import Foundation

actor AnalyticsClient {
    private let queue: SyncQueue
    private let metadataProvider: AnalyticsMetadataProvider
    private let validator: AnalyticsValidator
    private let encoder = JSONEncoder()

    init(queue: SyncQueue, metadataProvider: AnalyticsMetadataProvider, validator: AnalyticsValidator) {
        self.queue = queue
        self.metadataProvider = metadataProvider
        self.validator = validator
    }

    func track(_ event: AnalyticsEvent) async throws {
        let envelope = metadataProvider.makeEnvelope(for: event)
        try validator.validate(envelope)
        let payload = try encoder.encode(["events": [envelope]])
        let operation = SyncOperation(operationType: .analyticsEvent, endpointPath: "v1/analytics/events", payload: payload)
        await queue.enqueue(operation)
    }
}
