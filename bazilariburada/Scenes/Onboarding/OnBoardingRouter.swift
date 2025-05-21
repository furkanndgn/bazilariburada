//
//  OnBoardingRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 12.05.2025.
//

import UIKit

final class OnBoardingRouter {

    func createOnboardingScreen() -> UIViewController {
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
    func pushRegistrationScreen(_ sender: UIViewController) {
        let router = SignUpRouter()
        let viewController = router.createRegistrationScreen()
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
