//
//  RegistrationRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import UIKit

@MainActor
final class SignUpRouter {

    var loginRouter: LoginRouter?
    var activationViewController: ActivationViewController?

    var onUserLoggedIn: Completion?

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
        Task { @MainActor in
            loginRouter = LoginRouter()
            loginRouter?.onUserLoggedIn = { [weak self] in
                self?.onUserLoggedIn?()
            }
            let viewController = loginRouter!.createLoginScreen()
            sender.navigationController?.pushWithFade(viewController)
        }
    }

    func pushLoginScreen(_ sender: BaseViewController, activationViewController: ActivationViewController) {
        Task { @MainActor in
            loginRouter = LoginRouter()
            loginRouter?.onUserLoggedIn = { [weak self] in
                self?.onUserLoggedIn?()
            }
            let viewController = loginRouter!.createLoginScreen()
            sender.navigationController?.pushWithFade(viewController)
            activationViewController.navigationController?.popViewController(animated: false)
        }
    }

    func pushActivationScreen(with email: String, _ sender: UIViewController) {
        Task { @MainActor in
            let viewModel = ActivationViewModel(email: email)
            activationViewController = ActivationViewController(viewModel)
            activationViewController!.onFinish = { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.activationViewController?.navigationController?.popViewController(animated: false)
                        self?.pushLoginScreen(
                            sender as! BaseViewController,
                            activationViewController: (self?.activationViewController)!
                        )
                    case .failure:
                        self?.activationViewController?.navigationController?.popViewController(animated: true)
                    }
                }
            }
            sender.navigationController?.pushViewController(activationViewController!, animated: true)
        }
    }
}
