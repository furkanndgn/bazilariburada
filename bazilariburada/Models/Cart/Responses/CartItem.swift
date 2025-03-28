//
//  CartItem.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct CartItem: Decodable {
    let productID, productName: String
    let quantity: Int
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case productName, quantity, price
    }
}
