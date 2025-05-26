//
//  ResetPasswordViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import Foundation
import Combine

final class ResetPasswordViewModel: AuthenticationViewModel {

    @Published var activationCode = ""
    @Published var newPassword = ""
    @Published private(set) var isUpdateEnabled = false
    @Published private(set) var isCodeValid = false
    @Published private(set) var isPasswordValid = false

    private var cancellables = Set<AnyCancellable>()

    private let email: String

    init(email: String) {
        self.email = email
        super.init()
        addSubscribers()
    }

    func resetPassword(completion: @escaping StatusHandler) {
        Task {
            let statusCode = await authenticationService.resetPassword(
                email: email,
                resetPasswordCode: activationCode,
                newPassword: newPassword
            )
            completion(statusCode)
        }
    }
}


// MARK: - Setup Subscribers
private extension ResetPasswordViewModel {
    func addSubscribers() {
        Publishers
            .CombineLatest($isCodeValid, $isPasswordValid)
            .map { $0 && $1 }
            .assign(to: &$isUpdateEnabled)
        $activationCode
            .sink { [weak self] activationCode in
                self?.isCodeValid = activationCode.count == 6
            }
            .store(in: &cancellables)
        
        $newPassword
            .map { CredentialValidator.validatePassword($0) }
            .assign(to: &$isPasswordValid)
    }
}
