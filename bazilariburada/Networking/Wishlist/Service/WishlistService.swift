//
//  WishlistService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.03.2025.
//

import Foundation
import Combine

/// For endpoints in `Wishlist` collection
final class WishlistService: WishlistServiceProtocol {

    static var shared: WishlistServiceProtocol = WishlistService()

    private let networkManager: NetworkManagerProtocol
    private let wishlistSubject = PassthroughSubject<Wishlist?, Never>()

    var wishlistPublisher: AnyPublisher<Wishlist?, Never> {
        wishlistSubject.eraseToAnyPublisher()
    }

    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getUserWishlist(with accessToken: String) async {
        do {
            let response: APIResponse<Wishlist> = try await networkManager.performRequest(
                endpoint: WishlistEndpoint.getWishlist,
                token: accessToken
            )
            wishlistSubject.send(response.data)
        } catch let error {
            print(error)
        }
    }

    func addItemToWishlist(_ productID: String, with accessToken: String) async {
        let addWishlistRequest = AddToWishListRequest(productId: productID)
        do {
            let response: APIResponse<Wishlist> = try await networkManager.performRequest(
                endpoint: WishlistEndpoint.addProductToWishlist,
                token: accessToken,
                body: addWishlistRequest
            )
            wishlistSubject.send(response.data)
        } catch let error {
            print(error)
        }
    }

    func removeFromWishlist(productID: String, with accessToken: String) async {
        do {
            let response: APIResponse<Wishlist> = try await networkManager.performRequest(
                endpoint: WishlistEndpoint.removeProductFromWishlist(productID: productID),
                token: accessToken
            )
            wishlistSubject.send(response.data)
        } catch let error {
            print(error)
        }
    }

    func clearWishlist(with accessToken: String) async {
        do {
            let response: APIResponse<Wishlist> = try await networkManager.performRequest(
                endpoint: WishlistEndpoint.clearUserWishlist,
                token: accessToken
            )
            wishlistSubject.send(response.data)
        } catch let error {
            print(error)
        }
    }
}
