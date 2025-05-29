//
//  CartServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol CartServiceProtocol {

    static var shared: CartServiceProtocol { get }

    var currentCartPublisher: AnyPublisher<Cart?, Never> { get }
    
    func getUserCart(accessToken: String) async
    func addToCart(productID: String, quantity: Int, accessToken: String) async
    func updateQuantity(of productID: String, with quantity: Int, accessToken: String) async
    func removeFromCart(productID: String, accessToken: String) async
    func emptyCart(of accessToken: String) async
}
