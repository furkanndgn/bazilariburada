//
//  RegistrationViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 13.05.2025.
//

import Foundation
import Combine

final class SignUpViewModel: AuthenticationViewModel {

    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isRegisterEnabled = false
    @Published private(set) var isEmailValid = false
    @Published private(set) var isUsernameValid = false
    @Published private(set) var isPasswordValid = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init()
        addSubscribers()
    }

    func register(completion: @escaping StatusHandler) {
        Task {
            let statusCode = await authenticationService.registerUser(
                username: username,
                email: email,
                password: password
            )
            completion(statusCode)
        }
    }
}


// MARK: - Helpers
private extension SignUpViewModel {
    func addSubscribers() {
        Publishers
            .CombineLatest3($isEmailValid, $isPasswordValid, $isUsernameValid)
            .map { $0 && $1 && $2}
            .assign(to: &$isRegisterEnabled)
        $email
            .map { [weak self] in self?.validateEmail($0) ?? false }
            .assign(to: &$isEmailValid)
        $username
            .map { CredentialValidator.validateUsername($0)}
            .assign(to: &$isUsernameValid)
        $password
            .map { CredentialValidator.validatePassword($0) }
            .assign(to: &$isPasswordValid)
    }

    func validateEmail(_ email: String) -> Bool {
        do {
            try CredentialValidator.validateEmail(email)
        } catch {
            return false
        }
        return true
    }
}
