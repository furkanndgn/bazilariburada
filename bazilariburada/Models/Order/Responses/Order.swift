//
//  Order.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct Order: Decodable {
    let orderID, date: String
    let totalAmount: Double
    let items: [CartItem]
    
    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case date, totalAmount, items
    }
}
