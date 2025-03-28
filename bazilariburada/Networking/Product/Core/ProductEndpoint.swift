//
//  ProductEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum ProductEndpoint: APIEndpointProtocol {

    case getAllProducts(pagination: Pagination? = nil)
    case getProduct(productID: String)

    var isRequiringAuthentication: Bool {
        return false
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .getAllProducts:
            return ("/products", .GET)
        case .getProduct(let productID):
            return ("/products/\(productID)", .GET)
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllProducts(let pagination):
            return pagination?.queryItems
        case .getProduct:
            return nil
        }
    }
}
