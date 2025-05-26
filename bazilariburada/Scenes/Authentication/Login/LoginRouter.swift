//
//  LoginRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import UIKit

final class LoginRouter {

    var router: ForgotPasswordRouter?

    var onUserLoggedIn: Completion?

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
        router = ForgotPasswordRouter()
        let viewController = router!.createForgotPasswordScreen()
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
