//
//  ResetPasswordRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 22.05.2025.
//

import Foundation

final class ResetPasswordRouter {
    func createResetPasswordScreen(email : String) -> BaseViewController {
        let viewModel = ResetPasswordViewModel(email: email)
        let viewController = ResetPasswordViewController(viewModel)
        viewController.onRoute = { [weak self] in
            guard let self else { return }
            switch $0 {
            case .toLogin(let sender):
                self.popToLogin(sender)
            case .toForgotPassword(let sender):
                self.popToForgotPassword(sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension ResetPasswordRouter {
    func popToLogin(_ sender: BaseViewController) {
        let loginViewController = sender.navigationController?.viewControllers.first(
            where: { $0 is LoginViewController})
        guard let loginViewController else { return }
        sender.navigationController?.popToViewController(loginViewController, animated: true)
    }

    func popToForgotPassword(_ sender: BaseViewController) {
        sender.navigationController?.popViewController(animated: true)
    }
}
