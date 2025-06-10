//
//  Address.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation

struct Address: Codable {
    var id = UUID()
    var addressName: String
    var fullName: String
    var fullStreetAddress: String
    var city: String
    var country: String
    var isSelected: Bool = false
}
