//
//  OrderEndpoint.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

enum OrderEndpoint: APIEndpointProtocol {

    case placeOrder
    case getOrder(orderID: String)
    case getAllOrders

    var isRequiringAuthentication: Bool {
        return true
    }

    var pathAndMethod: (path: String, method: HTTPMethod) {
        switch self {
        case .placeOrder:
            return ("/orders", .POST)
        case .getOrder(let orderID):
            return ("/orders/\(orderID)", .GET)
        case .getAllOrders:
            return ("/orders", .GET)
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }


}
