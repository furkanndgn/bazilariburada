//
//  AddItemToCartRequest.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.03.2025.
//

import Foundation

struct AddItemToCartRequest: Encodable {
    let productId: String
    let quantity: Int
}
