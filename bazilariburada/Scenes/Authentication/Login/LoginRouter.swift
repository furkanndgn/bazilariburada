//
//  LoginRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import UIKit

final class LoginRouter {

    static let shared = LoginRouter()

    var onUserLoggedIn: Completion?

    private init() {}

    func createLoginScreen() -> BaseViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel)
        viewController.onRoute = { [weak self] in
            guard let self else { return }
            switch $0 {
            case .toMainScreen(_):
                self.onUserLoggedIn?()
            case .toRegisterScreen(let sender):
                self.popToRegisterScreen(sender)
            case .toForgotPasswordScreen(let sender):
                self.pushForgotPasswordScreen(sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension LoginRouter {
    func popToRegisterScreen(_ sender: BaseViewController) {
        sender.navigationController?.popWithFade()
    }

    func pushForgotPasswordScreen(_ sender: BaseViewController) {
        let viewController = ForgotPasswordRouter.shared.createForgotPasswordScreen()
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
