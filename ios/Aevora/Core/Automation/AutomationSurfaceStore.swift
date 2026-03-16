import Foundation

struct AutomationVowSnapshot: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let type: String
    let isCompleteToday: Bool
}

struct AutomationSurfacePayload: Codable, Equatable {
    let activeVows: [AutomationVowSnapshot]
}

enum AutomationSurfacePersistence {
    static let payloadKey = "automation.surface.payload.v1"

    static func load() -> AutomationSurfacePayload {
        let defaults = GlanceSurfacePersistence.defaults()
        guard let data = defaults.data(forKey: payloadKey),
              let payload = try? JSONDecoder().decode(AutomationSurfacePayload.self, from: data) else {
            return AutomationSurfacePayload(activeVows: [])
        }
        return payload
    }

    static func save(_ payload: AutomationSurfacePayload) {
        guard let data = try? JSONEncoder().encode(payload) else {
            return
        }
        GlanceSurfacePersistence.defaults().set(data, forKey: payloadKey)
    }
}

struct AutomationSurfaceStore {
    @MainActor
    func save(from coreLoop: FirstPlayableStore) {
        let payload = AutomationSurfacePayload(
            activeVows: coreLoop.activeVows.map {
                AutomationVowSnapshot(id: $0.id, title: $0.title, type: $0.type, isCompleteToday: $0.isCompleteToday)
            }
        )
        AutomationSurfacePersistence.save(payload)
    }
}
