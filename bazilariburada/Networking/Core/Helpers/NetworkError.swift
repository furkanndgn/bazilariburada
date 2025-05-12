//
//  NetworkErrors.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case missingToken
    case serverError(statusCode: Int, message: String, responseData: Data)
    case encodingFailed(context: String, underlyingError: Error)
    case decodingFailed(context: String, underlyingError: Error)
    case authenticationRequired
    case timeout
    case maxRetriesReached(Int)
    case unknown(Error?)

    var isRetryable: Bool {
        switch self {
        case .serverError(let code, _, _):
            return [408, 429, 500, 502, 503, 504].contains(code)
        case .timeout:
            return true
        default:
            return false
        }
    }
}
