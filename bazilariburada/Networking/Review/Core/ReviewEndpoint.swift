//
//  ReviewEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum ReviewEndpoint: APIEndpointProtocol {

    case getProductReviews(productID: String)
    case addReview(productID: String)
    case deleteReview(productID: String)

    var isRequiringAuthentication: Bool {
        switch self {
        case .getProductReviews:
            return false
        case .addReview, .deleteReview:
            return true
        }
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .getProductReviews(let productID):
            return ("/products/\(productID)/reviews", .GET)
        case .addReview(let productID):
            return ("/products/\(productID)/reviews", .POST)
        case .deleteReview(let productID):
            return ("/products/\(productID)/reviews", .DELETE)
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
