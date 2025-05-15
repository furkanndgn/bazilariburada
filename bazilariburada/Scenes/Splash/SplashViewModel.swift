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

    var accessToken: String?

    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
        accessToken = nil
    }

    func getAccessToken() async {
    }

    func validateTokens(completion: @escaping Completion) async {
        completion()
    }

    func runSplashLogic(completion: @escaping Completion) {
    }
}
