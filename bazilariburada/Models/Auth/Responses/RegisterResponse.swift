//
//  RegisterResponse.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation

struct RegisterResponse: Codable {
    let userID: String
    let email: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case email, message
        case userID = "userId"
    }
}
