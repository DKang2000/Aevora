import Foundation

private final class CopyCatalogBundleToken {}

struct CopyCatalog {
    private let strings: [String: String]

    init(bundle: Bundle = .main) {
        let bundles = [bundle, Bundle(for: CopyCatalogBundleToken.self)] + Bundle.allBundles + Bundle.allFrameworks
        let url = bundles.lazy.compactMap { $0.url(forResource: "core.v1", withExtension: "json") }.first

        if let url,
           let data = try? Data(contentsOf: url),
           let raw = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
            strings = raw
        } else {
            strings = [:]
        }
    }

    func text(_ key: String, fallback: String) -> String {
        strings[key] ?? fallback
    }
}
