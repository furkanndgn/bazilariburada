//
//  NetworkManagerProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol NetworkManagerProtocol {

    static var shared: NetworkManagerProtocol { get }

    func performRequest<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        body: U?,
        responseType: T.Type,
        token: String?,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    )

    func performRequest<T: Decodable>(
        endpoint: APIEndpointProtocol,
        responseType: T.Type,
        token: String?,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    )
}


// MARK: - Convenience Methods with Default Parameters
extension NetworkManagerProtocol {
    func performRequest<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        body: U?,
        responseType: T.Type,
        token: String? = nil,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    ) {
        performRequest(endpoint: endpoint, body: body, responseType: responseType, token: token, completion: completion)
    }

    func performRequest<T: Decodable>(
        endpoint: APIEndpointProtocol,
        responseType: T.Type,
        token: String? = nil,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    ) {
        performRequest(endpoint: endpoint, responseType: responseType, token: token, completion: completion)
    }
}
