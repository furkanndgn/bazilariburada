//
//  Order.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct Order {
    let orderID, date: String?
    let totalAmount: Double?
    let items: [CartItem]?
}
