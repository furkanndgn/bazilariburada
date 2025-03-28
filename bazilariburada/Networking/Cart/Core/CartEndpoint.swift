//
//  CartEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum CartEndpoint: APIEndpointProtocol {

    case getUserCart
    case addProductToCart
    case updateQuantity(productID: String)
    case removeProductFromCart(productID: String)
    case emptyCart


    var isRequiringAuthentication: Bool {
        return true
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .getUserCart:
            return ("/cart", .GET)
        case .addProductToCart:
            return ("/cart", .POST)
        case .updateQuantity(let productID):
            return ("/cart/\(productID)", .PATCH)
        case .removeProductFromCart(let productID):
            return ("/cart/\(productID)", .DELETE)
        case .emptyCart:
            return ("/cart", .DELETE)
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
