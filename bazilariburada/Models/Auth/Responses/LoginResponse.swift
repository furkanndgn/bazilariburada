//
//  LoginResponse.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation
 
struct LoginResponse: Decodable {
    let username: String
    let accessToken: String
    let refreshToken: String
}
