//
//  CartServices.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation
import Combine

/// For endpoints in `Cart` collection
final class CartService: CartServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    private var currentCartSubject = PassthroughSubject<Result<Cart, NetworkError>, Never>()

    var currentCartPublisher: AnyPublisher<Result<Cart, NetworkError>, Never> {
        currentCartSubject.eraseToAnyPublisher()
    }

    func addToCart(productID: String, quantity: Int, accessToken: String) {
        let cartRequest = AddItemToCartRequest(productID: productID, quantity: quantity)
        networkManager
            .performRequest(
                endpoint: CartEndpoint.addProductToCart,
                body: cartRequest,
                responseType: Cart.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.currentCartSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.currentCartSubject.send(.failure(networkError))
                }
            }
    }

    func updateQuantity(of productID: String, with quantity: Int, accessToken: String) {
        let updateQuantityRequest = UpdateItemQuantityRequest(quantity: quantity)
        networkManager
            .performRequest(
                endpoint: CartEndpoint.updateQuantity(productID: productID),
                body: updateQuantityRequest,
                responseType: Cart.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.currentCartSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.currentCartSubject.send(.failure(networkError))
                }
            }
    }

    func removeFromCart(productID: String, accessToken: String) {
        networkManager
            .performRequest(
                endpoint: CartEndpoint.removeProductFromCart(productID: productID),
                responseType: Cart.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.currentCartSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.currentCartSubject.send(.failure(networkError))
                }
            }
    }

    func emptyCart(of accessToken: String) {
        networkManager
            .performRequest(
                endpoint: CartEndpoint.emptyCart,
                responseType: Cart.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.currentCartSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.currentCartSubject.send(.failure(networkError))
                }
            }
    }
}
