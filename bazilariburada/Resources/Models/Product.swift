//
//  Product.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct Product {
    let id, name, description, imageURL, category, brand, weight: String?
    let price: Double?
    let quantity: Int?
    let reviews: [Review]?
}
