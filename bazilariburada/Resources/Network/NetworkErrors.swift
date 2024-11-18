//
//  NetworkErrors.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(description: String)
    case decodingFailed
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknown
    
    // A user-friendly description of the error
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid. Please check the endpoint."
        case .requestFailed(let description):
            return "The network request failed with error: \(description)"
        case .decodingFailed:
            return "Failed to decode the response. The data format might be incorrect."
        case .unauthorized:
            return "You are not authorized to access this resource. Please log in."
        case .forbidden:
            return "Access to this resource is forbidden."
        case .notFound:
            return "The requested resource was not found."
        case .serverError:
            return "The server encountered an error. Please try again later."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
