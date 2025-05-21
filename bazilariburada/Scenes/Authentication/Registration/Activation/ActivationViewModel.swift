//
//  ActivationViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import Foundation

final class ActivationViewModel: AuthenticationViewModel {

    let email: String

    init(email: String) {
        self.email = email
    }

    func activateAccount(_ activationCode: String, completion: @escaping StatusHandler) {
        Task {
            let statusCode = await authenticationService.activateAccount(
                email: email,
                activationCode: activationCode
            )
            completion(statusCode)
        }
    }
}
