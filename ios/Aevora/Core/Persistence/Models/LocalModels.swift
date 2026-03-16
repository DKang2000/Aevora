import Foundation
import SwiftData

@Model
final class UserSessionSnapshot {
    @Attribute(.unique) var id: String
    var authMode: String
    var timezone: String
    var createdAt: Date

    init(id: String, authMode: String, timezone: String, createdAt: Date = .now) {
        self.id = id
        self.authMode = authMode
        self.timezone = timezone
        self.createdAt = createdAt
    }
}

@Model
final class LocalVowRecord {
    @Attribute(.unique) var id: String
    var title: String
    var type: String
    var lifecycle: String
    var updatedAt: Date

    init(id: String, title: String, type: String, lifecycle: String, updatedAt: Date = .now) {
        self.id = id
        self.title = title
        self.type = type
        self.lifecycle = lifecycle
        self.updatedAt = updatedAt
    }
}

@Model
final class LocalSyncOperationRecord {
    @Attribute(.unique) var id: String
    var operationType: String
    var payload: Data
    var status: String
    var createdAt: Date

    init(id: String, operationType: String, payload: Data, status: String, createdAt: Date = .now) {
        self.id = id
        self.operationType = operationType
        self.payload = payload
        self.status = status
        self.createdAt = createdAt
    }
}

@Model
final class LocalChapterSnapshot {
    @Attribute(.unique) var id: String
    var chapterID: String
    var payload: Data
    var updatedAt: Date

    init(id: String, chapterID: String, payload: Data, updatedAt: Date = .now) {
        self.id = id
        self.chapterID = chapterID
        self.payload = payload
        self.updatedAt = updatedAt
    }
}

@Model
final class LocalDistrictSnapshot {
    @Attribute(.unique) var id: String
    var districtID: String
    var payload: Data
    var updatedAt: Date

    init(id: String, districtID: String, payload: Data, updatedAt: Date = .now) {
        self.id = id
        self.districtID = districtID
        self.payload = payload
        self.updatedAt = updatedAt
    }
}

@Model
final class LocalSubscriptionCache {
    @Attribute(.unique) var id: String
    var tier: String
    var payload: Data
    var updatedAt: Date

    init(id: String, tier: String, payload: Data, updatedAt: Date = .now) {
        self.id = id
        self.tier = tier
        self.payload = payload
        self.updatedAt = updatedAt
    }
}

@Model
final class LocalRemoteConfigCache {
    @Attribute(.unique) var id: String
    var schemaVersion: String
    var payload: Data
    var updatedAt: Date

    init(id: String, schemaVersion: String, payload: Data, updatedAt: Date = .now) {
        self.id = id
        self.schemaVersion = schemaVersion
        self.payload = payload
        self.updatedAt = updatedAt
    }
}
