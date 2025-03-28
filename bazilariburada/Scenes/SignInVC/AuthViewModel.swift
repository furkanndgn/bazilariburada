//
//  SignInViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

class AuthViewModel {
    
    private let authService = AuthenticationService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func login(username: String, password: String) {

    }
    
    func register(username: String, email: String, password: String) {

    }
    
    func activateAccount(email: String, activationCode: String) {

    }
    
    func getResetPasswordCode(email: String) {

    }
    
    func resetPassword(securityCode: String, newPassword: String) {

    }
    
    private func addSubscribers() {

    }
}

