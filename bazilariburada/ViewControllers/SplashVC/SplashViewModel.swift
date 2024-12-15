//
//  SplashViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {
    
    private let authService: AuthenticationService
    var cancellables = Set<AnyCancellable>()
    private var refreshToken: String? = UserDefaults.standard.string(forKey: "refreshToken")
    var accessTokesn: String?
    
    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
        addSubscribers()
        getAccessToken()
    }

    func getAccessToken() {
        guard let refreshToken = refreshToken, !refreshToken.isEmpty else { return }
        authService.refreshAccessToken(refreshToken: refreshToken)
    }
    
    private func addSubscribers() {
        authService.$loginData
            .sink { [weak self] data in
                self?.refreshToken = data?.refreshToken
                self?.accessTokesn = data?.accessToken
            }
            .store(in: &cancellables)
        authService.$refreshAccessTokenData
            .sink { [weak self] data in
                self?.refreshToken = data?.refreshToken
                self?.accessTokesn = data?.accessToken
            }
            .store(in: &cancellables)
    }
}
