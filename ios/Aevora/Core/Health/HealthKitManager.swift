import Foundation

#if canImport(HealthKit)
import HealthKit
#endif

enum HealthKitPermissionSnapshot: String, Codable, Equatable {
    case notDetermined
    case authorized
    case denied
    case unavailable
}

enum HealthKitDomain: String, Codable, CaseIterable, Equatable {
    case workout
    case steps
    case sleep
}

struct VerifiedHealthSample: Equatable {
    let sourceEventID: String
    let domain: HealthKitDomain
    let localDate: String
    let quantity: Int?
    let durationMinutes: Int?
}

@MainActor
protocol HealthKitManaging {
    func authorizationStatus() async -> HealthKitPermissionSnapshot
    func requestAuthorization(for domains: [HealthKitDomain]) async -> HealthKitPermissionSnapshot
    func recentSamples(since: Date?) async -> [VerifiedHealthSample]
}

@MainActor
final class SystemHealthKitManager: HealthKitManaging {
#if canImport(HealthKit)
    private let store = HKHealthStore()
#endif

    func authorizationStatus() async -> HealthKitPermissionSnapshot {
#if canImport(HealthKit)
        guard HKHealthStore.isHealthDataAvailable() else {
            return .unavailable
        }
        let status = store.authorizationStatus(for: HKObjectType.workoutType())
        switch status {
        case .sharingAuthorized:
            return .authorized
        case .sharingDenied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
#else
        return .unavailable
#endif
    }

    func requestAuthorization(for domains: [HealthKitDomain]) async -> HealthKitPermissionSnapshot {
#if canImport(HealthKit)
        guard HKHealthStore.isHealthDataAvailable() else {
            return .unavailable
        }

        var readTypes: Set<HKObjectType> = [HKObjectType.workoutType()]
        if domains.contains(.steps), let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            readTypes.insert(stepsType)
        }
        if domains.contains(.sleep), let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) {
            readTypes.insert(sleepType)
        }

        return await withCheckedContinuation { continuation in
            store.requestAuthorization(toShare: [], read: readTypes) { granted, _ in
                continuation.resume(returning: granted ? .authorized : .denied)
            }
        }
#else
        return .unavailable
#endif
    }

    func recentSamples(since: Date?) async -> [VerifiedHealthSample] {
        // Keep v1 narrow and deterministic in-app. Simulator and CI flows use the stub manager.
        // Device builds can replace this with richer queries without changing the app-facing contract.
        _ = since
        return []
    }
}

@MainActor
final class StubHealthKitManager: HealthKitManaging {
    var status: HealthKitPermissionSnapshot
    var samples: [VerifiedHealthSample]

    init(
        status: HealthKitPermissionSnapshot = .notDetermined,
        samples: [VerifiedHealthSample] = []
    ) {
        self.status = status
        self.samples = samples
    }

    func authorizationStatus() async -> HealthKitPermissionSnapshot {
        status
    }

    func requestAuthorization(for domains: [HealthKitDomain]) async -> HealthKitPermissionSnapshot {
        _ = domains
        return status
    }

    func recentSamples(since: Date?) async -> [VerifiedHealthSample] {
        guard let since else {
            return samples
        }
        let formatter = ISO8601DateFormatter()
        return samples.filter { sample in
            guard let date = formatter.date(from: "\(sample.localDate)T00:00:00Z") else {
                return true
            }
            return date >= since
        }
    }
}
