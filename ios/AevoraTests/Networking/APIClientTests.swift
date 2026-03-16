import XCTest
@testable import Aevora

private struct MockTransport: HTTPTransport {
    let data: Data
    let statusCode: Int

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
}

private struct EchoResponse: Codable, Equatable {
    let ok: Bool
}

final class APIClientTests: XCTestCase {
    func testBuildsIdempotentRequest() throws {
        let client = APIClient(baseURL: URL(string: "https://example.com")!)
        let request = try client.makeURLRequest(APIRequest<EchoResponse>(path: "v1/completions", method: "POST", idempotencyKey: "req_1"))
        XCTAssertEqual(request.value(forHTTPHeaderField: "Idempotency-Key"), "req_1")
    }

    func testDecodesSuccessfulResponse() async throws {
        let client = APIClient(
            baseURL: URL(string: "https://example.com")!,
            transport: MockTransport(data: try JSONEncoder().encode(EchoResponse(ok: true)), statusCode: 200)
        )

        let response: EchoResponse = try await client.send(APIRequest(path: "v1/health"))
        XCTAssertEqual(response, EchoResponse(ok: true))
    }
}
