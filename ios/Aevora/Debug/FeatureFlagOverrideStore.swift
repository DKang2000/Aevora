import Foundation

@MainActor
final class FeatureFlagOverrideStore: ObservableObject {
    @Published private var overrides: [FeatureFlag: Bool] = [:]

    func set(_ value: Bool?, for flag: FeatureFlag) {
        overrides[flag] = value
    }

    func value(for flag: FeatureFlag) -> Bool? {
        overrides[flag]
    }
}
