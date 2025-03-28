//
//  Cart.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct Cart: Decodable {
    let cartItems: [CartItem]
    let totalPrice: Double
}
