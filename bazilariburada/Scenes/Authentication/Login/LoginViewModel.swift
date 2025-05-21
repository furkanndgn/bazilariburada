//
//  LoginViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import Foundation
import Combine

final class LoginViewModel: AuthenticationViewModel {

    @Published var username = ""
    @Published var password = ""
    @Published private(set) var isLoginEnabled = false
    @Published private(set) var isUsernameValid = false
    @Published private(set) var isPasswordValid = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init()
        addSubscribers()
    }

    func login(completion: @escaping StatusHandler) {
        Task {
            let statusCode = await authenticationService.loginUsing(username: username, password: password)
            completion(statusCode)
        }
    }
}


// MARK: - Subscribers
private extension LoginViewModel {
    func addSubscribers() {
        Publishers
            .CombineLatest($isUsernameValid, $isPasswordValid)
            .map { $0 && $1 }
            .assign(to: &$isLoginEnabled)
        $username
            .map { CredentialValidator.validateUsername($0) }
            .assign(to: &$isUsernameValid)
        $password
            .map { CredentialValidator.validatePassword($0) }
            .assign(to: &$isPasswordValid)
    }
}
