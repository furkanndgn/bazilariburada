//
//  ApiError.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation

struct APIError: Codable {
    let field: String?
    let errorMessage: String?
    let rejectedValue: String?
}
