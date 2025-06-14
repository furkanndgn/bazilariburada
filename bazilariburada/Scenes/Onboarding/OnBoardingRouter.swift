//
//  OnBoardingRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 12.05.2025.
//

import UIKit

@MainActor
final class OnBoardingRouter {

    static let shared = OnBoardingRouter()

    var onUserLoggedIn: Completion?

    private init() {}

    func createOnboardingScreen() -> BaseViewController {
        let viewController = OnboardingViewController()
        viewController.onRoute = { [weak self] in
            guard let self else { return }
            switch $0 {
            case .toRegisterScene(let sender):
                self.pushRegistrationScreen(sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension OnBoardingRouter {
    func pushRegistrationScreen(_ sender: BaseViewController) {
        SignUpRouter.shared.onUserLoggedIn = { [weak self] in
            self?.onUserLoggedIn?()
        }
        let viewController = SignUpRouter.shared.createRegistrationScreen()
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
