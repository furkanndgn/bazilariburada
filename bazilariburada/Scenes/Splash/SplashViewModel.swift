//
//  SplashViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import Foundation

final class SplashViewModel: ObservableObject {

    private let authenticationManager = AuthenticationManager.shared
    private let authService: AuthenticationService

    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
    }

    func validateTokens() async -> Bool {
        guard let token = await authenticationManager.accessToken else {
            return false
        }
        print(token)
        return true
    }
}


enum TokenValidation {
    case valid, invalid
}
