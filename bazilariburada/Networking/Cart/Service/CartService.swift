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

    private var currentCartSubject = PassthroughSubject<APIResponse<Cart>?, Never>()

    var currentCartPublisher: AnyPublisher<APIResponse<Cart>?, Never> {
        currentCartSubject.eraseToAnyPublisher()
    }

    func addToCart(productID: String, quantity: Int, accessToken: String) async {
        let cartRequest = AddItemToCartRequest(productId: productID, quantity: quantity)
        do {
            let response: APIResponse<Cart> = try await networkManager.performRequest(
                endpoint: CartEndpoint.addProductToCart,
                token: accessToken,
                body: cartRequest
            )
            currentCartSubject.send(response)
        } catch let error {
            print(error)
        }
    }

    func updateQuantity(of productID: String, with quantity: Int, accessToken: String) async {
        let updateQuantityRequest = UpdateItemQuantityRequest(quantity: quantity)
        do {
            let response: APIResponse<Cart> = try await networkManager.performRequest(
                endpoint: CartEndpoint.updateQuantity(productID: productID),
                token: accessToken,
                body: updateQuantityRequest
            )
            currentCartSubject.send(response)
        } catch let error {
            print(error)
        }
    }

    func removeFromCart(productID: String, accessToken: String) async {
        do {
            let response: APIResponse<Cart> = try await networkManager.performRequest(
                endpoint: CartEndpoint.removeProductFromCart(productID: productID),
                token: accessToken
            )
            currentCartSubject.send(response)
        } catch let error {
            print(error)
        }
    }

    func emptyCart(of accessToken: String) async {
        do {
            let response: APIResponse<Cart> = try await networkManager.performRequest(
                endpoint: CartEndpoint.emptyCart,
                token: accessToken
            )
            currentCartSubject.send(response)
        } catch let error {
            print(error)
        }
    }
}
