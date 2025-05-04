//
//  SignInViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

final class AuthViewModel {

    private let authService: AuthenticationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthenticationServiceProtocol = AuthenticationService()) {
        self.authService = authService
        addSubscribers()
    }
    
    func login(username: String, password: String) {
        authService.loginUsing(username: username, password: password) { result in
            switch result {
            case .success(let response):
                print(response.accessToken)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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

