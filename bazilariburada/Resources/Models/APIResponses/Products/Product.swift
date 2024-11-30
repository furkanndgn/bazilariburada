//
//  Product.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct Product: Codable {
    let id, name, description, imageURL, category, brand, weight: String?
    let price, averageRating: Double?
    let quantity: Int?
    let reviews: [Review]?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case id, name, description, category, brand, weight
        case price, averageRating, quantity, reviews
    }
}
