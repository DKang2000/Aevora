import Foundation

enum APIError: Error, Equatable {
    case invalidResponse
    case server(statusCode: Int)
    case decodingFailed
    case transportFailed
}
