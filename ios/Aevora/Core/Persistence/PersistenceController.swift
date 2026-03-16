import Foundation
import SwiftData

@MainActor
final class PersistenceController {
    let container: ModelContainer
    let mainContext: ModelContext

    init(inMemory: Bool = false) {
        let schema = Schema([
            UserSessionSnapshot.self,
            LocalVowRecord.self,
            LocalSyncOperationRecord.self,
            LocalChapterSnapshot.self,
            LocalDistrictSnapshot.self,
            LocalCoreLoopSnapshot.self,
            LocalSubscriptionCache.self,
            LocalRemoteConfigCache.self
        ])

        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        do {
            container = try ModelContainer(for: schema, configurations: configuration)
            mainContext = ModelContext(container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
