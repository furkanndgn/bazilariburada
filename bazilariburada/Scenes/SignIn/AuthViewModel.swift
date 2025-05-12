//
//  SignInViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

final class AuthViewModel {

    private let authManager = AuthenticationManager.shared

    private let authService: AuthenticationServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthenticationServiceProtocol = AuthenticationService()) {
        self.authService = authService
        addSubscribers()
    }

    //    func login(username: String, password: String) {
    //        authService.loginUsing(username: username, password: password) { [weak self] result in
    //            switch result {
    //            case .success(let response):
    //                Task {
    //                    try? await self?.authManager
    //                        .saveTokens(
    //                            accessToken: response.accessToken,
    //                            accessExpiresAt: Date().addingTimeInterval(86400),
    //                            refreshToken: response.refreshToken,
    //                            refreshExpiresAt: Date().addingTimeInterval(604800)
    //                        )
    //                    do {
    //                        try await self?.authManager
    //                            .saveTokens(
    //                                accessToken: response.accessToken,
    //                                accessExpiresAt: Date().addingTimeInterval(86400),
    //                                refreshToken: response.refreshToken,
    //                                refreshExpiresAt: Date().addingTimeInterval(604800)
    //                            )
    //                    } catch let error {
    //                        print(error.localizedDescription)
    //                    }
    //                }
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }

    func login(with username: String =  "furkido", password: String = "12345678") {
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

