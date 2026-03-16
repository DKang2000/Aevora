import Foundation

struct AnalyticsEnvelope: Codable, Equatable {
    let eventName: String
    let eventVersion: String
    let occurredAtUTC: String
    let localDate: String
    let userID: String?
    let anonymousDeviceID: String?
    let sessionID: String
    let surface: String
    let appBuild: String
    let platform: String
    let experimentAssignments: [String]
    let properties: [String: String]
}
