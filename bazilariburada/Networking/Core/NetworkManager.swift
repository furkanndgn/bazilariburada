//
//  NetworkManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {

    static let shared: NetworkManagerProtocol = NetworkManager()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init(session: URLSession = .shared,
                 decoder: JSONDecoder = .init(),
                 encoder: JSONEncoder = .init()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func performRequest<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        body: U? = nil,
        timeoutInterval: TimeInterval = 30.0
    ) async throws -> APIResponse<T> {
        let request = try buildRequest(for: endpoint, body: body, token: token, timeoutInterval: timeoutInterval)
#if DEBUG
        logRequest(request)
#endif
        return try await withThrowingTaskGroup(of: APIResponse<T>.self) { group in
            group.addTask { [weak self] in
                guard let self else { throw NetworkError.unknown(nil) }
                return try await self.executeRequest(request)
            }

            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeoutInterval * 1_000_000_000))
                throw NetworkError.timeout
            }

            do {
                let result = try await group.next()!
                group.cancelAll()
                return result
            } catch {
                group.cancelAll()
                throw error
            }
        }
    }

    func performRequestWithRetry<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        body: U?,
        maxRetries: Int = 3,
        initialDelay: TimeInterval = 1.0
    ) async throws -> APIResponse<T> {
        var currentDelay = initialDelay

        for _ in 0..<maxRetries {
            do {
                return try await performRequest(endpoint: endpoint, token: token, body: body)
            } catch {
                guard (error as? NetworkError)?.isRetryable ?? false else { throw error }

                try await Task.sleep(nanoseconds: UInt64(currentDelay * 1_000_000_000))
                currentDelay *= 2
            }
        }
        throw NetworkError.maxRetriesReached(maxRetries)
    }

}


// MARK: - For Requests Without Body
extension NetworkManager {
    func performRequest<T: Decodable>(
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        timeoutInterval: TimeInterval = 30.0
    ) async throws -> APIResponse<T> {
        try await performRequest(
            endpoint: endpoint,
            body: Optional<EmptyRequest>.none,
            timeoutInterval: timeoutInterval
        )
    }
    func performRequestWithRetry<T: Decodable>(
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        maxRetries: Int = 3,
        initialDelay: TimeInterval = 1.0
    ) async throws -> APIResponse<T> {
        try await performRequestWithRetry(
            endpoint: endpoint,
            body: Optional<EmptyRequest>.none,
            maxRetries: maxRetries,
            initialDelay: initialDelay
        )
    }
}


// MARK: - Private Implementation
private extension NetworkManager {
    func buildRequest<U: Encodable>(
        for endpoint: APIEndpointProtocol,
        body: U? = nil,
        token: String? = nil,
        timeoutInterval: TimeInterval = 30
    ) throws -> URLRequest {
        guard let url = APIURLBuilder.buildURL(for: endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: timeoutInterval
        )

        request.httpMethod = endpoint.pathAndMethod.method.rawValue
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        if endpoint.isRequiringAuthentication {
            guard let token = token else { throw NetworkError.missingToken }
            request.addValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }

        if let body = body {
            do {
                request.httpBody = try encode(body: body)
            } catch {
                throw NetworkError
                    .encodingFailed(context: "Request body encoding failed", underlyingError: error)
            }
        }

        return request
    }

    func executeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
#if DEBUG
        logResponse(response, data: data)
#endif
        try validate(response: response, data: data)
        return try decode(data: data)
    }

    func encode(body: Encodable) throws -> Data {
        do {
            return try encoder.encode(body)
        } catch let error as EncodingError {
            throw NetworkError.encodingFailed(context: "Request body encoding failed", underlyingError: error)
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorResponse = try? decoder.decode(APIResponse<APIError>.self, from: data)
            throw NetworkError.serverError(
                statusCode: httpResponse.statusCode,
                message: errorResponse?.message ?? "Server error",
                responseData: data
            )
        }
    }

    func decode<T: Decodable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(context: "Response decoding failed", underlyingError: error)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}


// MARK: - Logging
private extension NetworkManager {
    func logRequest(_ request: URLRequest) {
        let headers = request.allHTTPHeaderFields?.map { "\($0.key): \($0.value)" }.joined(separator: "\n") ?? "None"
        let body = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "Empty"

        print("""
        🌐 [Network Request]
        URL: \(request.url?.absoluteString ?? "nil")
        Method: \(request.httpMethod ?? "nil")
        Headers:
        \(headers)
        Body:
        \(body)
        """)
    }

    func logResponse(_ response: URLResponse, data: Data) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let body = String(data: data, encoding: .utf8) ?? "Unable to decode response body"

        print("""
        📩 [Network Response]
        Status Code: \(httpResponse.statusCode)
        Headers:
        \(httpResponse.allHeaderFields.map { "\($0.key): \($0.value)" }.joined(separator: "\n"))
        Body:
        \(body)
        """)
    }
}
