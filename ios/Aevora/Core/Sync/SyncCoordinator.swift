import Foundation

final class SyncCoordinator {
    private let apiClient: APIClient
    private let queue: SyncQueue
    private let isNetworkAvailable: @Sendable () async -> Bool

    init(apiClient: APIClient, queue: SyncQueue, isNetworkAvailable: @escaping @Sendable () async -> Bool) {
        self.apiClient = apiClient
        self.queue = queue
        self.isNetworkAvailable = isNetworkAvailable
    }

    func flush() async {
        guard await isNetworkAvailable() else { return }

        let operations = await queue.pendingOperations()
        for operation in operations {
            let request = APIRequest<EmptyResponse>(
                path: operation.endpointPath,
                method: "POST",
                body: operation.payload,
                idempotencyKey: operation.id
            )

            do {
                _ = try await apiClient.send(request)
                await queue.markApplied(operation.id)
            } catch {
                await queue.markRetryableFailure(operation.id)
            }
        }
    }
}

struct EmptyResponse: Decodable, Equatable {}
