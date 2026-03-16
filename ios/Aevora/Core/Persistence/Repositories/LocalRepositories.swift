import Foundation
import SwiftData

@MainActor
protocol LocalStoreRepository {
    func saveSession(_ session: UserSessionSnapshot) throws
    func saveVow(_ vow: LocalVowRecord) throws
    func fetchVows() throws -> [LocalVowRecord]
    func enqueueOperation(_ operation: LocalSyncOperationRecord) throws
    func fetchQueuedOperations() throws -> [LocalSyncOperationRecord]
    func saveCoreLoopSnapshot(payload: Data) throws
    func fetchCoreLoopSnapshot() throws -> LocalCoreLoopSnapshot?
    func saveSubscriptionState(payload: Data, tier: String) throws
    func fetchSubscriptionState() throws -> LocalSubscriptionCache?
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
        if let existing = try modelContext.fetch(FetchDescriptor<UserSessionSnapshot>()).first(where: { $0.id == session.id }) {
            existing.authMode = session.authMode
            existing.timezone = session.timezone
            existing.createdAt = session.createdAt
        } else {
            modelContext.insert(session)
        }
        try modelContext.save()
    }

    func saveVow(_ vow: LocalVowRecord) throws {
        if let existing = try modelContext.fetch(FetchDescriptor<LocalVowRecord>()).first(where: { $0.id == vow.id }) {
            existing.title = vow.title
            existing.type = vow.type
            existing.lifecycle = vow.lifecycle
            existing.updatedAt = vow.updatedAt
        } else {
            modelContext.insert(vow)
        }
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

    func saveCoreLoopSnapshot(payload: Data) throws {
        if let existing = try modelContext.fetch(FetchDescriptor<LocalCoreLoopSnapshot>()).first {
            existing.payload = payload
            existing.updatedAt = .now
        } else {
            modelContext.insert(LocalCoreLoopSnapshot(id: "first-playable", payload: payload))
        }
        try modelContext.save()
    }

    func fetchCoreLoopSnapshot() throws -> LocalCoreLoopSnapshot? {
        try modelContext.fetch(FetchDescriptor<LocalCoreLoopSnapshot>()).first
    }

    func saveSubscriptionState(payload: Data, tier: String) throws {
        if let existing = try modelContext.fetch(FetchDescriptor<LocalSubscriptionCache>()).first {
            existing.tier = tier
            existing.payload = payload
            existing.updatedAt = .now
        } else {
            let cache = LocalSubscriptionCache(id: "subscription-state", tier: tier, payload: payload)
            modelContext.insert(cache)
        }
        try modelContext.save()
    }

    func fetchSubscriptionState() throws -> LocalSubscriptionCache? {
        try modelContext.fetch(FetchDescriptor<LocalSubscriptionCache>()).first
    }

    func saveRemoteConfig(payload: Data, schemaVersion: String) throws {
        if let existing = try modelContext.fetch(FetchDescriptor<LocalRemoteConfigCache>()).first {
            existing.schemaVersion = schemaVersion
            existing.payload = payload
            existing.updatedAt = .now
        } else {
            let cache = LocalRemoteConfigCache(id: "remote-config", schemaVersion: schemaVersion, payload: payload)
            modelContext.insert(cache)
        }
        try modelContext.save()
    }

    func fetchRemoteConfigCache() throws -> LocalRemoteConfigCache? {
        try modelContext.fetch(FetchDescriptor<LocalRemoteConfigCache>()).first
    }
}
