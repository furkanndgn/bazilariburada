//
//  OrderService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

/// For endpoints in `Order` collection
final class OrderService: OrderServiceProtocol {

    static var shared: OrderServiceProtocol = OrderService()

    private let networkManager: NetworkManagerProtocol

    @Published var orders: [Order]?
    var allOrdersPublisher: AnyPublisher<[Order]?, Never> {
        $orders.eraseToAnyPublisher()
    }

    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func placeAnOrder(to address: String, with accessToken: String) async -> APIResponse<Order>? {
        let orderRequest = OrderRequest(address: address)
        do {
            return try await networkManager
                .performRequest(
                    endpoint: OrderEndpoint.placeOrder,
                    token: accessToken,
                    body: orderRequest
                )
        } catch let error {
            print(error)
        }
        return nil
    }

    func getUserOrder(by orderID: String, with accessToken: String) async -> APIResponse<Order>? {
        do {
            return try await networkManager
                .performRequest(
                    endpoint: OrderEndpoint.getOrder(orderID: orderID),
                    token: accessToken
                )
        } catch let error {
            print(error)
        }
        return nil
    }

    func getAllOrders(with accessToken: String) async {
        do {
            let response: APIResponse<[Order]> = try await networkManager
                .performRequest(
                    endpoint: OrderEndpoint.placeOrder,
                    token: accessToken
                )
            orders = response.data
        } catch let error {
            print(error)
        }
    }
}

