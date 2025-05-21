//
//  LoginRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import UIKit

final class LoginRouter {
    func createLoginScreen() -> BaseViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel)
        viewController.onRoute = { [weak self] in
            guard let self else { return }
            switch $0 {
            case .toMainScreen(let sender):
                self.swapToAppFlow(sender)
            case .toRegisterScreen(let sender):
                self.popToRegisterScreen(sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension LoginRouter {
    func swapToAppFlow(_ sender: BaseViewController) {
        Task {
            await MainActor.run {
                guard let scene = sender.view.window?.windowScene else {
                    print("No active UIWindowScene found.")
                    return
                }

                if let window = scene.windows.first {
                    let transition = CATransition()
                    transition.type = .fade
                    transition.duration = 0.3
                    window.layer.add(transition, forKey: kCATransition)
                    let tabBar = TabBarViewController()
                    window.rootViewController = tabBar
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    func popToRegisterScreen(_ sender: BaseViewController) {
        sender.navigationController?.popViewController(animated: true)
    }
}
