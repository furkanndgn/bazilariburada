//
//  APIEndpointProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol APIEndpointProtocol {
    var isRequiringAuthentication: Bool { get }
    var pathAndMethod: (path: String, method: HTTPMethod) { get }
    var queryItems: [URLQueryItem]? { get }
}
