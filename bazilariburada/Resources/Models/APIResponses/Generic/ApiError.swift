//
//  ApiError.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation

struct ApiError: Codable {
    let field: String?
    let errorMessage: String?
    let rejectedValue: String?
}
