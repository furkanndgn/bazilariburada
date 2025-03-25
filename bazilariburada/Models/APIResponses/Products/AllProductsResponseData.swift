//
//  AllProductResponseData.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation

struct AllProductsResponseData: Decodable {
    let products: [Product]
    let totalProducts: Int
    let totalPages: Int
    let currentPage: Int
}
