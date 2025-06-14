//
//  AppRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 22.05.2025.
//

import UIKit

@MainActor
final class AppRouter {

    private let window: UIWindow
    private var onboardingRouter = OnBoardingRouter.shared
    private var tabBarViewController: UITabBarController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showSplash()
    }

    private func showSplash() {
        let splashViewController = SplashViewController()
        splashViewController.onComplete = { [weak self] userLoggedIn in
            if userLoggedIn {
                self?.startAppFlow()
            } else {
                self?.startAuthenticationFlow()
            }
        }
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }

    private func startAuthenticationFlow() {
        Task { @MainActor in
            onboardingRouter.onUserLoggedIn = { [weak self] in
                self?.startAppFlow()
            }
            let viewController = onboardingRouter.createOnboardingScreen()
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    private func startAppFlow() {
        Task { @MainActor in
            tabBarViewController = MainTabBarController()
            UIView.transition(
                with: window,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    self.window.rootViewController = self.tabBarViewController
                },
                completion: nil
            )
            window.makeKeyAndVisible()
        }
    }
}
