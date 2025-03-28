//
//  CartServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol CartServiceProtocol {

    var currentCartPublisher: AnyPublisher<Result<Cart, NetworkError>, Never> { get }

    func addToCart(productID: String, quantity: Int, accessToken: String)
    func updateQuantity(of productID: String, with quantity: Int, accessToken: String)
    func removeFromCart(productID: String, accessToken: String)
    func emptyCart(of accessToken: String)
}
