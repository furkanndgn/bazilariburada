//
//  NetworkErrors.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(URLError)
    case missingToken
    case decodingFailed(underlyingError: DecodingError)
    case serverError(statusCode: Int, message: String? = nil)
    case encodingFailed(underlyingError: EncodingError)
    case unauthorized(message: String? = nil)
    case invalidResponse
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please verify the endpoint."
        case .requestFailed(let urlError):
            return "Network request failed: \(urlError.localizedDescription)"
        case .missingToken:
            return "Authentication required. Please log in."
        case .decodingFailed(let error):
            return "Data parsing failed: \(error.contextualDescription)"
        case .serverError(let statusCode, let message):
            return message ?? "Server error (HTTP \(statusCode))"
        case .encodingFailed(let error):
            return "Request encoding failed: \(error.localizedDescription)"
        case .unauthorized(let message):
            return message ?? "Session expired. Please re-authenticate."
        case .invalidResponse:
            return "Received malformed server response."
        case .unknown(let error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }
}
