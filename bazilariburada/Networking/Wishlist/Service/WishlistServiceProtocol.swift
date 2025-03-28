//
//  WishlistServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol WishlistServiceProtocol {

    var wishlistPublisher: AnyPublisher<Result<[WishlistItem], NetworkError>, Never> { get }

    func getUserWishlist(with accessToken: String)
    func addToWishlist(productID: String, with accessToken: String)
    func removeFromWishlist(productID: String, with accessToken: String)
    func clearWishlist(with accessToken: String)
}
