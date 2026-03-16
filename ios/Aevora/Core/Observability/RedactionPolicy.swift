import Foundation

struct RedactionPolicy {
    func sanitize(_ metadata: [String: String]) -> [String: String] {
        metadata.reduce(into: [String: String]()) { partialResult, item in
            switch item.key {
            case "user_id", "session_id", "anonymous_device_id":
                partialResult[item.key] = "<redacted>"
            case "note_text", "healthkit_payload":
                break
            default:
                partialResult[item.key] = item.value
            }
        }
    }
}
