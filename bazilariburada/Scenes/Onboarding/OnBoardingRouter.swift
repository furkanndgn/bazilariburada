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
        viewController.onRoute = {
            switch $0 {
            case .toRegisterScene(let sender):
                self.pushRegistrationScreen(sender)
            }
        }
        return viewController
    }
}


private extension OnBoardingRouter {
    func pushRegistrationScreen(_ sender: UIViewController) {
        let viewController = RegistrationViewController(RegistrationViewModel())
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
