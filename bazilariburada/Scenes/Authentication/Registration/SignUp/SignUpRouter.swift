//
//  RegistrationRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import UIKit

final class SignUpRouter {
    func createRegistrationScreen() -> BaseViewController {
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController(viewModel)
        viewController.onRoute = {
            switch $0 {
            case .toLoginScreen(let sender):
                self.pushLoginScreen(sender)
            case .toActivationScreen(let sender, let email):
                self.pushActivationScreen(with: email, sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension SignUpRouter {

    func pushLoginScreen(_ sender: BaseViewController) {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }

    func pushActivationScreen(with email: String, _ sender: UIViewController) {

    }
}
