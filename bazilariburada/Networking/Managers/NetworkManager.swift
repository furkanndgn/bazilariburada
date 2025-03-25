//
//  NetworkManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case GET, POST, DELETE, PATCH
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL: String = "https://grocery-app-backend-45m3.onrender.com/api/v1"
    private let token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: [String: Any]? = nil,
        requiresAuthentication: Bool = false,
        token: String? = nil
    ) -> AnyPublisher<ApiResponse<T>, Error> {
        request(endpoint: endpoint, method: method, body: body, requiresAuthentication: requiresAuthentication, token: token)
            .decode(type: ApiResponse<T>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Overload for `null` data responses
    func performRequest(
        endpoint: String,
        method: HTTPMethod,
        body: [String: Any]? = nil,
        requiresAuthentication: Bool = false,
        token: String? = nil
    ) -> AnyPublisher<ApiResponse<EmptyResponseData>, Error> {
        request(endpoint: endpoint, method: method, body: body, requiresAuthentication: requiresAuthentication, token: token)
            .decode(type: ApiResponse<EmptyResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func request(
        endpoint: String,
        method: HTTPMethod,
        body: [String: Any]? = nil,
        requiresAuthentication: Bool = false,
        token: String? = nil
    ) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuthentication, let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ try self.handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }
    
    private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.decodingFailed
        }
        switch response.statusCode {
        case 200..<300:
            return output.data
        case 401:
            throw NetworkError.unauthorized
        case 500..<600:
            throw NetworkError.serverError
        default:
            return output.data
        }
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(String(describing: error.localizedDescription))
        }
    }
}
