//
//  Address.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation

struct Address: Codable {
    var id = UUID()
    var name: String
    var line1: String
    var line2: String?
    var city: String
    var postalCode: String
    var country: String
    var isSelected: Bool = false
}
