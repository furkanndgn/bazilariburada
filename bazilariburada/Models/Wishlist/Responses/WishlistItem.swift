//
//  WishlistItem.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.03.2025.
//

import Foundation

struct WishlistItem: Decodable {
    let id, name, description, imageURL: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case name, description, id, price
    }

}
