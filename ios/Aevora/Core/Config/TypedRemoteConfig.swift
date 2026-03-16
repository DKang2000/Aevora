import Foundation

struct TypedRemoteConfig: Codable, Equatable {
    struct Widgets: Codable, Equatable {
        let basicWidgetEnabled: Bool
        let advancedWidgetRefreshMinutes: Int
    }

    let schemaVersion: String
    let featureFlags: [String: Bool]
    let economy: [String: Double]
    let onboarding: [String: String]
    let paywall: [String: String]
    let reminders: [String: Double]
    let widgets: Widgets
    let liveActivities: [String: Bool]
    let chapterGating: [String: String]
}
