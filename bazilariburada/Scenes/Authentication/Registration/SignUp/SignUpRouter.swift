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
        viewController.onRoute = { [weak self] in
            guard let self else { return }
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
        let router = LoginRouter()
        let viewController = router.createLoginScreen()
        sender.navigationController?.pushViewController(viewController, animated: true)
    }

    func pushActivationScreen(with email: String, _ sender: UIViewController) {
        let router = ActivationRouter()
        let viewController = router.createActivationScreenWith(email: email)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
