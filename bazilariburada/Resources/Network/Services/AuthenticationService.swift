//
//  AuthenticationService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

class AuthenticationService {
    private let networkManager = NetworkManager.shared
    
    func register(username: String, email: String, password: String) {
        let body = ["username": username, "email": email, "password": password]
        networkManager.request(endpoint: "/auth/register", method: .POST, body: body)
        
    }

}
