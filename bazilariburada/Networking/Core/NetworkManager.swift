//
//  NetworkManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {

    static var shared: NetworkManagerProtocol = NetworkManager()

    func performRequest<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        body: U?,
        responseType: T.Type,
        token: String? = nil,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    ) {

        guard let url = APIURLBuilder.buildURL(for: endpoint) else {
            return completion(.failure(.invalidURL))
        }

        var request = buildRequest(with: url, and: endpoint)

        if endpoint.isRequiringAuthentication {
            addToken(&request, token: token) { error in
                completion(.failure(error))
            }
        }

        if let body = body {
            addBody(&request, body: body) { error in
                completion(.failure(error))
            }
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                return completion(.failure(.unknown(error)))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            }

            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                    completion(.success(jsonData))
                } catch let error {
                    if let decodingError = error as? DecodingError {
                        return completion(.failure(.decodingFailed(underlyingError: decodingError)))
                    }
                    else {
                        return completion(.failure(.unknown(error)))
                    }
                }
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    func performRequest<T: Decodable>(
        endpoint: APIEndpointProtocol,
        responseType: T.Type,
        token: String? = nil,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    ) {
        performRequest(
            endpoint: endpoint,
            body: Optional<EmptyRequest>.none,
            responseType: responseType,
            token: token,
            completion: completion
        )
    }
}

private extension NetworkManager {

    func buildRequest(with url: URL, and endpoint: APIEndpointProtocol) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.pathAndMethod.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }


    func addToken(_ request: inout URLRequest, token: String?, completion: (NetworkError) -> Void) {
        guard let token = token else {
            return completion(.missingToken)
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    func addBody<T: Encodable>(
        _ request: inout URLRequest,
        body: T,
        completion: (NetworkError) -> Void
    )  {
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch let encodingError as EncodingError {
            completion(.encodingFailed(underlyingError: encodingError))
        } catch {
            completion(.unknown(error))
        }
    }
}
