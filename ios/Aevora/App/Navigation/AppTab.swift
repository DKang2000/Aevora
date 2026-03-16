import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case today
    case world
    case hearth
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: "Today"
        case .world: "World"
        case .hearth: "Hearth"
        case .profile: "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .today: "checklist"
        case .world: "sparkles"
        case .hearth: "house"
        case .profile: "person"
        }
    }
}
