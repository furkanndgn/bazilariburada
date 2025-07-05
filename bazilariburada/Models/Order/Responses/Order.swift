//
//  Order.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct OrderResponse: Decodable {
    let orders: [Order]
}

struct Order: Decodable {
    let orderID, address, date: String
    let totalAmount: Double
    let items: [CartItem]
    
    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case address, date, totalAmount, items
        case total
        case orderItems
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        orderID = try container.decode(String.self, forKey: .orderID)
        address = try container.decode(String.self, forKey: .address)
        date = try container.decode(String.self, forKey: .date)
        if let total = try? container.decode(Double.self, forKey: .totalAmount) {
            totalAmount = total
        } else {
            totalAmount = try container.decode(Double.self, forKey: .total)
        }
        if let items = try? container.decode([CartItem].self, forKey: .orderItems) {
            self.items = items
        } else {
            self.items = try container.decode([CartItem].self, forKey: .items)
        }
    }
}
