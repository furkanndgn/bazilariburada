//
//  AddReviewRequest.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.03.2025.
//

import Foundation

struct AddReviewRequest: Encodable {
    let rating: Int
    let comment: String
}
