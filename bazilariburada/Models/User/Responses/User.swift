//
//  User.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct User: Decodable {
    let username, password, email: String
    let cart: [CartItem]
    let orders: [Order]
}
