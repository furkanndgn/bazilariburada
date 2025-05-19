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

    @Published var isEmailValid = false
    @Published var isUsernameValid = false
    @Published var isPasswordValid = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init()
        addSubscribers()
    }

    func register(username: String, email: String, password: String, completion: @escaping StatusHandler) {
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
            .map { [weak self] in self?.validateUsername($0) ?? false}
            .assign(to: &$isUsernameValid)
        $password
            .map { [weak self] in self?.validatePassword($0) ?? false }
            .assign(to: &$isPasswordValid)
    }

    func validatePassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        return true
    }

    func validateUsername(_ username: String) -> Bool {
        guard username.count >= 3, username.count <= 20 else { return false }
        return true
    }

    func validateEmail(_ email: String) -> Bool {
        do {
            try EmailValidator.validateEmail(email)
        } catch {
            return false
        }
        return true
    }
}
