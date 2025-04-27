//
//  Product+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import Foundation

extension Product {
    static var sample = Product(
        id: "test",
        name: "test",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        imageURL: "test",
        category: "test",
        brand: "test",
        weight: "12",
        price: 12.3,
        averageRating: 3,
        quantity: 5,
        reviews: Review.samples
    )
}
