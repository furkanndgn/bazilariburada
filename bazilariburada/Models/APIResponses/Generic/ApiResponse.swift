//
//  ApiResponse.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String
    var data: T?
    let timestamp: String
    let errors: [ApiError]?
}
