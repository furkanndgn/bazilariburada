//
//  Pagination.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.03.2025.
//

import Foundation

struct Pagination {
    let offset: Int
    let limit: Int

    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
