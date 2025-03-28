//
//  WishlistEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum WishlistEndpoint: APIEndpointProtocol {

    case getWishlist
    case addProductToWishlist
    case removeProductFromWishlist(productID: String)
    case clearUserWishlist

    var isRequiringAuthentication: Bool {
        return true
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .getWishlist:
            return ("/wishlist", .GET)
        case .addProductToWishlist:
            return ("/wishlist", .PATCH)
        case .removeProductFromWishlist(let productID):
            return ("/wishlist/\(productID)", .DELETE)
        case .clearUserWishlist:
            return ("/wishlist", .DELETE)
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
