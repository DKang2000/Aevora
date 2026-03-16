import Foundation
import SwiftData

@MainActor
protocol LocalStoreRepository {
    func saveSession(_ session: UserSessionSnapshot) throws
    func saveVow(_ vow: LocalVowRecord) throws
    func fetchVows() throws -> [LocalVowRecord]
    func enqueueOperation(_ operation: LocalSyncOperationRecord) throws
    func fetchQueuedOperations() throws -> [LocalSyncOperationRecord]
    func saveRemoteConfig(payload: Data, schemaVersion: String) throws
    func fetchRemoteConfigCache() throws -> LocalRemoteConfigCache?
}

@MainActor
final class SwiftDataRepository: LocalStoreRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveSession(_ session: UserSessionSnapshot) throws {
        modelContext.insert(session)
        try modelContext.save()
    }

    func saveVow(_ vow: LocalVowRecord) throws {
        modelContext.insert(vow)
        try modelContext.save()
    }

    func fetchVows() throws -> [LocalVowRecord] {
        try modelContext.fetch(FetchDescriptor<LocalVowRecord>())
    }

    func enqueueOperation(_ operation: LocalSyncOperationRecord) throws {
        modelContext.insert(operation)
        try modelContext.save()
    }

    func fetchQueuedOperations() throws -> [LocalSyncOperationRecord] {
        try modelContext.fetch(FetchDescriptor<LocalSyncOperationRecord>())
    }

    func saveRemoteConfig(payload: Data, schemaVersion: String) throws {
        let cache = LocalRemoteConfigCache(id: "remote-config", schemaVersion: schemaVersion, payload: payload)
        modelContext.insert(cache)
        try modelContext.save()
    }

    func fetchRemoteConfigCache() throws -> LocalRemoteConfigCache? {
        try modelContext.fetch(FetchDescriptor<LocalRemoteConfigCache>()).first
    }
}
