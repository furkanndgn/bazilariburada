//
//  RegisterResponse.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation

struct RegisterResponse: Decodable {
    let userID, email, message: String
    
    enum CodingKeys: String, CodingKey {
        case email, message
        case userID = "userId"
    }
}
