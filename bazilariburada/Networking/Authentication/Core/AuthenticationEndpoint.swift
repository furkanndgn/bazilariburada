//
//  AuthenticationEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum AuthenticationEndpoint: APIEndpointProtocol {

    case register
    case activateAccount
    case login
    case forgotPassword
    case refreshAccessToken
    case resetPassword

    var isRequiringAuthentication: Bool {
        return false
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .register:
            return ("/auth/register", .POST)
        case .activateAccount:
            return ("/auth/activate", .PATCH)
        case .login:
            return ("/auth/login", .POST)
        case .forgotPassword:
            return ("/auth/forgot-password", .POST)
        case .refreshAccessToken:
            return ("/auth/refresh-token", .POST)
        case .resetPassword:
            return ("/auth/reset-password", .PATCH)
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
