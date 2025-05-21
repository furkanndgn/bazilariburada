//
//  ActivationRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.05.2025.
//

import UIKit

class ActivationRouter {
    func createActivationScreenWith(email: String) -> BaseViewController {
        let viewModel = ActivationViewModel(email: email)
        let viewController = ActivationViewController(viewModel)
        viewController.onRoute = { [weak self] in
            guard let self else { return }
            switch $0 {
            case .toMainScreen(let sender):
                self.swapToAppFlow(sender)
            case.toRegisterScreen(let sender):
                self.popToRegisterScreen(sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension ActivationRouter {
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
