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

    private let allOrdersSubject = PassthroughSubject<Result<[Order], NetworkError>, NetworkError>()

    var allOrdersPublisher: AnyPublisher<Result<[Order], NetworkError>, NetworkError> {
        allOrdersSubject.eraseToAnyPublisher()
    }

    func placeAnOrder(
        to address: String,
        with accessToken: String,
        completion: @escaping (Result<Order, NetworkError>) -> Void
    ) {
        let orderRequest = OrderRequest(address: address)
        networkManager
            .performRequest(
                endpoint: OrderEndpoint.placeOrder,
                body: orderRequest,
                responseType: Order.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        completion(.success(data))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }

    func getUserOrder(
        by orderID: String,
        with accessToken: String,
        completion: @escaping (Result<Order, NetworkError>) -> Void
    ) {
        networkManager
            .performRequest(
                endpoint: OrderEndpoint.getOrder(orderID: orderID),
                responseType: Order.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        completion(.success(data))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }

    func getAllOrders(with accessToken: String) {
        networkManager
            .performRequest(
                endpoint: OrderEndpoint.getAllOrders,
                responseType: [Order].self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.allOrdersSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.allOrdersSubject.send(.failure(networkError))
                }
            }
    }
}

