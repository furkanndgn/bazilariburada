//
//  APIConfig.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.03.2025.
//

import Foundation

enum APIConfig {
    case production, staging, local

    var baseURL: String {
        switch self {
        case .local: return "http://localhost:8080/api/v1"
        case .production: return ""
        case .staging: return "https://grocery-app-backend-45m3.onrender.com/api/v1"
        }
    }

    var headers: [String: String] {
        [
            "Content-Type": "application/json"
        ]
    }
}
