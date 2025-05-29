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


    static var shared: CartServiceProtocol = CartService()

    @Published var currentCart: Cart?
    var currentCartPublisher: AnyPublisher<Cart?, Never> {
        $currentCart.eraseToAnyPublisher()
    }

    private let networkManager: NetworkManagerProtocol

    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getUserCart(accessToken: String) async {
        do {
            let response: APIResponse<Cart> = try await networkManager.performRequest(
                endpoint: CartEndpoint.getUserCart,
                token: accessToken
            )
            currentCart = response.data
        } catch let error {
            print(error)
        }
    }

    func addToCart(productID: String, quantity: Int, accessToken: String) async {
        let cartRequest = AddItemToCartRequest(productId: productID, quantity: quantity)
        do {
            let response: APIResponse<Cart> = try await networkManager.performRequest(
                endpoint: CartEndpoint.addProductToCart,
                token: accessToken,
                body: cartRequest
            )
            currentCart = response.data
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
            currentCart = response.data
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
            currentCart = response.data
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
            currentCart = response.data
        } catch let error {
            print(error)
        }
    }
}
