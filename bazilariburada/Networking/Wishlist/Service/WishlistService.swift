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

    private let networkManager: NetworkManagerProtocol

    private let wishlistSubject = PassthroughSubject<Result<[WishlistItem], NetworkError>, Never>()

    var wishlistPublisher: AnyPublisher<Result<[WishlistItem], NetworkError>, Never> {
        wishlistSubject.eraseToAnyPublisher()
    }

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getUserWishlist(with accessToken: String) {
        networkManager
            .performRequest(
                endpoint: WishlistEndpoint.getWishlist,
                responseType: [WishlistItem].self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.wishlistSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.wishlistSubject.send(.failure(networkError))
                }
            }
    }

    func addToWishlist(productID: String, with accessToken: String) {
        let addWishlistRequest = AddToWishListRequest(productID: productID)
        networkManager
            .performRequest(
                endpoint: WishlistEndpoint.addProductToWishlist,
                body: addWishlistRequest,
                responseType: [WishlistItem].self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.wishlistSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.wishlistSubject.send(.failure(networkError))
                }
            }
    }

    func removeFromWishlist(productID: String, with accessToken: String) {
        networkManager
            .performRequest(
                endpoint: WishlistEndpoint.removeProductFromWishlist(productID: productID),
                responseType: [WishlistItem].self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.wishlistSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.wishlistSubject.send(.failure(networkError))
                }
            }
    }

    func clearWishlist(with accessToken: String) {
        networkManager
            .performRequest(
                endpoint: WishlistEndpoint.getWishlist,
                responseType: [WishlistItem].self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.wishlistSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.wishlistSubject.send(.failure(networkError))
                }
            }
    }
}
