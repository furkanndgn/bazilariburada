//
//  ForgotPasswordRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import Foundation

final class ForgotPasswordRouter {

    static let shared = ForgotPasswordRouter()

    private init() {}

    func createForgotPasswordScreen() -> BaseViewController {
        let viewModel = ForgotPasswordViewModel()
        let viewController = ForgotPasswordViewController(viewModel)
        viewController.onRoute = { [weak self] in
            guard let self else { return }
            switch $0 {
            case .toResetPassword(let sender, let email):
                self.pushResetPasswordScreen(sender, email: email)
            case .toLogin(let sender):
                self.popToLoginScreen(sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension ForgotPasswordRouter {
    func pushResetPasswordScreen(_ sender: BaseViewController, email: String) {
        let viewController = ResetPasswordRouter.shared.createResetPasswordScreen(email: email)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }

    func popToLoginScreen(_ sender: BaseViewController) {
        sender.navigationController?.popWithFade()
    }
}
