//
//  SplashViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import Foundation

class SplashViewModel: ObservableObject {
    
    let authService: AuthenticationService
    var refreshToken: String? = UserDefaults.standard.string(forKey: "refreshToken")
    
    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
    }

    func getAccessToken() {
        guard let refreshToken = refreshToken else { return }
        authService.refreshAccessToken(refreshToken: refreshToken)
    }
    
    func addSubscribers() {
        authService.$refreshAccessTokenData
            .
    }
}
