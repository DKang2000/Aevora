import Foundation

struct AnalyticsMetadataProvider {
    func makeEnvelope(for event: AnalyticsEvent) -> AnalyticsEnvelope {
        let formatter = ISO8601DateFormatter()
        let now = Date()

        return AnalyticsEnvelope(
            eventName: event.name.rawValue,
            eventVersion: "v1",
            occurredAtUTC: formatter.string(from: now),
            localDate: DateFormatter.aevoraLocalDate.string(from: now),
            userID: nil,
            anonymousDeviceID: "device_local",
            sessionID: UUID().uuidString,
            surface: event.surface,
            appBuild: "1.0.0",
            platform: "ios",
            experimentAssignments: [],
            properties: event.properties
        )
    }
}

private extension DateFormatter {
    static let aevoraLocalDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
