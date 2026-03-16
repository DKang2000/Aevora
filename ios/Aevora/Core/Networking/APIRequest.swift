import Foundation

struct APIRequest<Response: Decodable> {
    let path: String
    let method: String
    var headers: [String: String] = [:]
    var body: Data?
    var idempotencyKey: String?

    init(path: String, method: String = "GET", headers: [String: String] = [:], body: Data? = nil, idempotencyKey: String? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.idempotencyKey = idempotencyKey
    }
}

protocol HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

struct URLSessionTransport: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        return (data, http)
    }
}
