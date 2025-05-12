//
//  WishlistServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol WishlistServiceProtocol {

    var wishlistPublisher: AnyPublisher<[WishlistItem]?, Never> { get }

    func getUserWishlist(with accessToken: String) async
    func addToWishlist(productID: String, with accessToken: String) async
    func removeFromWishlist(productID: String, with accessToken: String) async
    func clearWishlist(with accessToken: String) async
}
