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

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    private let allOrdersSubject = PassthroughSubject<APIResponse<[Order]>?, Never>()

    var allOrdersPublisher: AnyPublisher<APIResponse<[Order]>?, Never> {
        allOrdersSubject.eraseToAnyPublisher()
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
            allOrdersSubject.send(response)
        } catch let error {
            print(error)
        }
    }
}

