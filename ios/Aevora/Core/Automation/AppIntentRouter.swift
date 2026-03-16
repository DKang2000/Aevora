import Foundation

@MainActor
final class AppIntentRouter {
    static let shared = AppIntentRouter()

    var openHandler: ((AppDeepLinkDestination) -> Void)?
    var completeVowHandler: ((String) -> Void)?

    private init() {}

    func open(_ destination: AppDeepLinkDestination) {
        openHandler?(destination)
    }

    func completeVow(id: String) {
        completeVowHandler?(id)
    }
}
