import Foundation

final class APIClient {
    private let baseURL: URL
    private let transport: HTTPTransport
    private let decoder = JSONDecoder()
    private let authTokenProvider: () -> String?

    init(baseURL: URL, transport: HTTPTransport = URLSessionTransport(), authTokenProvider: @escaping () -> String? = { nil }) {
        self.baseURL = baseURL
        self.transport = transport
        self.authTokenProvider = authTokenProvider
    }

    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response {
        let urlRequest = try makeURLRequest(request)
        let (data, response) = try await transport.send(urlRequest)

        guard (200..<300).contains(response.statusCode) else {
            throw APIError.server(statusCode: response.statusCode)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }

    func makeURLRequest<Response>(_ request: APIRequest<Response>) throws -> URLRequest {
        let url = baseURL.appending(path: request.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = request.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authTokenProvider() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let idempotencyKey = request.idempotencyKey {
            urlRequest.setValue(idempotencyKey, forHTTPHeaderField: "Idempotency-Key")
        }

        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }

        return urlRequest
    }
}
