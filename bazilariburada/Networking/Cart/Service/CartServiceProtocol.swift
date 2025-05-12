//
//  CartServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol CartServiceProtocol {

    var currentCartPublisher: AnyPublisher<APIResponse<Cart>?, Never> { get }

    func addToCart(productID: String, quantity: Int, accessToken: String) async
    func updateQuantity(of productID: String, with quantity: Int, accessToken: String) async
    func removeFromCart(productID: String, accessToken: String) async
    func emptyCart(of accessToken: String) async
}
