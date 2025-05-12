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
        token: String?,
        body: U?,
        timeoutInterval: TimeInterval
    ) async throws -> APIResponse<T>

    func performRequest<T: Decodable>(
        endpoint: APIEndpointProtocol,
        token: String?,
        timeoutInterval: TimeInterval
    ) async throws -> APIResponse<T>

    func performRequestWithRetry<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        token: String?,
        body: U?,
        maxRetries: Int,
        initialDelay: TimeInterval
    ) async throws -> APIResponse<T>

    func performRequestWithRetry<T: Decodable>(
        endpoint: APIEndpointProtocol,
        token: String?,
        maxRetries: Int,
        initialDelay: TimeInterval
    ) async throws -> APIResponse<T>
}


// MARK: - Convenience Methods with Default Parameters
extension NetworkManagerProtocol {
    func performRequest<T: Decodable, U: Encodable> (
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        body: U?,
        timeoutInterval: TimeInterval = 30.0
    ) async throws -> APIResponse<T> {
        try await performRequest(endpoint: endpoint, token: token, body: body, timeoutInterval: timeoutInterval)
    }

    func performRequest<T: Decodable> (
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        timeoutInterval: TimeInterval = 30.0
    ) async throws -> APIResponse<T> {
        try await performRequest(endpoint: endpoint, token: token, timeoutInterval: timeoutInterval)
    }

    func performRequestWithRetry<T: Decodable, U: Encodable>(
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        body: U?,
        maxRetries: Int = 3,
        initialDelay: TimeInterval = 1
    ) async throws -> APIResponse<T> {
        try await performRequestWithRetry(
            endpoint: endpoint,
            token: token,
            body: body,
            maxRetries: maxRetries,
            initialDelay: initialDelay
        )
    }
    func performRequestWithRetry<T: Decodable>(
        endpoint: APIEndpointProtocol,
        token: String? = nil,
        maxRetries: Int = 3,
        initialDelay: TimeInterval = 1
    ) async throws -> APIResponse<T> {
        try await performRequestWithRetry(
            endpoint: endpoint,
            token: token,
            maxRetries: maxRetries,
            initialDelay: initialDelay
        )
    }
}
