//
//  ActivationViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import Foundation
import Combine

final class ActivationViewModel: AuthenticationViewModel {

    @Published var activationCode = ""
    @Published private(set) var isActivateEnabled = false

    let email: String

    private var cancellables = Set<AnyCancellable>()

    init(email: String) {
        self.email = email
    }

    func activateAccount(email: String, activationCode: String, completion: @escaping StatusHandler) {
        Task {
            let statusCode = await authenticationService.activateAccount(
                email: email,
                activationCode: activationCode
            )
            completion(statusCode)
        }
    }
}


// MARK: - Helpers
private extension ActivationViewModel {
    func addSubscribers() {

    }

    func validateActivationCode() -> Bool {
        return false
    }
}
