import Foundation

enum RemoteConfigError: Error, Equatable {
    case invalidPayload
}

@MainActor
final class RemoteConfigClient {
    private let defaultsLoader: () throws -> Data
    private let overrideProvider: (FeatureFlag) -> Bool?
    private var cachedConfig: TypedRemoteConfig?
    private let decoder = JSONDecoder()

    init(defaultsLoader: @escaping () throws -> Data, overrideProvider: @escaping (FeatureFlag) -> Bool?) {
        self.defaultsLoader = defaultsLoader
        self.overrideProvider = overrideProvider
    }

    func loadDefaults() throws -> TypedRemoteConfig {
        let data = try defaultsLoader()
        let raw = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard
            let raw,
            raw["schemaVersion"] != nil,
            raw["featureFlags"] as? [String: Bool] != nil,
            raw["widgets"] != nil
        else {
            throw RemoteConfigError.invalidPayload
        }

        let config = try decoder.decode(TypedRemoteConfig.self, from: data)
        cachedConfig = config
        return config
    }

    func featureFlag(_ flag: FeatureFlag) throws -> Bool {
        if let override = overrideProvider(flag) {
            return override
        }

        let config = try cachedConfig ?? loadDefaults()
        return config.featureFlags[flag.rawValue] ?? false
    }
}
