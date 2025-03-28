//
//  WishlistItem.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.03.2025.
//

import Foundation

struct WishlistItem: Decodable {
    let productID, name, description, imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case productID = "id"
        case name, description
    }

}
