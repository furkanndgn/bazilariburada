//
//  RegisterRequest.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.03.2025.
//

import Foundation

struct RegisterRequest: Encodable {
    let username: String
    let email: String
    let password: String
}
