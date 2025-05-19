//
//  Authentication.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

class AuthenticationViewModel {

    private let authManager = AuthenticationManager.shared

    internal let authenticationService: AuthenticationServiceProtocol

    init(authService: AuthenticationServiceProtocol = AuthenticationService()) {
        self.authenticationService = authService
    }

    func login(with username: String =  "furkido", password: String = "12345678") {
    }


    func getResetPasswordCode(email: String) {

    }

    func resetPassword(securityCode: String, newPassword: String) {

    }
}

