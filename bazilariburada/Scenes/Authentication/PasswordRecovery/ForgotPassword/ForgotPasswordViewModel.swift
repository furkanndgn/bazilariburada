//
//  ForgotPasswordViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import Foundation
import Combine

final class ForgotPasswordViewModel: AuthenticationViewModel {

    @Published var email = ""
    @Published private(set) var isEmailValid = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init()
    }

    func sendCode(completion: @escaping StatusHandler) {
        Task {
            let statusCode = await authenticationService.sendResetPasswordCode(to: email)
            completion(statusCode)
        }
    }
}



// MARK: - Subscriptions
private extension ForgotPasswordViewModel{

    func addSubscribers() {
        $email
            .map { [weak self] in self?.validateEmail($0) ?? false }
            .assign(to: &$isEmailValid)
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
