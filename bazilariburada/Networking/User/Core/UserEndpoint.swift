//
//  UserEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum UserEndpoint: APIEndpointProtocol {

    case getUserProfile
    case updateUser

    var isRequiringAuthentication: Bool {
        return true
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .getUserProfile:
            return ("/users/profile", .GET)
        case .updateUser:
            return ("/users/profile", .PATCH)
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
