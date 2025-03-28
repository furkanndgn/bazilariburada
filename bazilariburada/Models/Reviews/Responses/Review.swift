//
//  Review.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import Foundation

struct Review: Decodable {
    let username, comment, date: String
    let rating: Int
}
