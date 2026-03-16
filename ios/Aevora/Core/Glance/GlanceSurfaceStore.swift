import Foundation
import WidgetKit

struct GlanceSurfaceStore {
    func load() -> GlanceSurfacePayload {
        GlanceSurfacePersistence.load()
    }

    func save(_ payload: GlanceSurfacePayload) {
        GlanceSurfacePersistence.save(payload)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
