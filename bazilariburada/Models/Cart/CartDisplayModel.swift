//
//  CartDisplayModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.05.2025.
//

import Foundation

struct CartDisplayModel: Identifiable {
    let cartItem: CartItem
    let product: Product
    var id: String { product.id }
}
