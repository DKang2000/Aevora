import Foundation

enum AppDeepLinkDestination: String {
    case today
    case world
    case questJournal = "quest_journal"
}

enum AppDeepLink {
    static func url(
        source: GlanceSurfaceDeepLinkSource,
        destination: AppDeepLinkDestination,
        vowID: String? = nil
    ) -> URL {
        var components = URLComponents(string: "aevora://open")!
        var queryItems = [
            URLQueryItem(name: "source", value: source.rawValue),
            URLQueryItem(name: "destination", value: destination.rawValue)
        ]
        if let vowID {
            queryItems.append(URLQueryItem(name: "vowId", value: vowID))
        }
        components.queryItems = queryItems
        return components.url!
    }
}
