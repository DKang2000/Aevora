import Foundation

enum AnalyticsValidationError: Error, Equatable {
    case unknownEvent
    case prohibitedField
}

struct AnalyticsValidator {
    func validate(_ envelope: AnalyticsEnvelope) throws {
        guard AnalyticsEventName(rawValue: envelope.eventName) != nil else {
            throw AnalyticsValidationError.unknownEvent
        }

        let prohibitedKeys = ["note_text", "healthkit_payload"]
        if envelope.properties.keys.contains(where: { prohibitedKeys.contains($0) }) {
            throw AnalyticsValidationError.prohibitedField
        }
    }
}
