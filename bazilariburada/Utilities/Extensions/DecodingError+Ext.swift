//
//  DecodingError+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.03.2025.
//

import Foundation

/// Helper extension for DecodingError
extension DecodingError {
    var contextualDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            return "Type mismatch for \(type) at \(context.codingPathString)"
        case .valueNotFound(let type, let context):
            return "Missing value for \(type) at \(context.codingPathString)"
        case .keyNotFound(let key, let context):
            return "Missing key \(key.stringValue) at \(context.codingPathString)"
        case .dataCorrupted(let context):
            return "Corrupted data at \(context.codingPathString): \(context.debugDescription)"
        @unknown default:
            return localizedDescription
        }
    }
}

extension DecodingError.Context {
    var codingPathString: String {
        codingPath.map { $0.stringValue }.joined(separator: " → ")
    }
}
