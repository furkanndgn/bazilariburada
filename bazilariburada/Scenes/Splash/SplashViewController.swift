//
//  SplashViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

final class SplashViewController: UIViewController {

    let viewModel: SplashViewModel

    init(viewModel: SplashViewModel = SplashViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        Task {
//            await viewModel.getAccessToken()
            await MainActor.run {
                self.transitionToMainApp()
            }
        }
    }
}


private extension SplashViewController {
    func transitionToMainApp() {
        guard let scene = view.window?.windowScene else {
            print("No active UIWindowScene found.")
            return
        }

        if let window = scene.windows.first {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
            let tabBar = createTabBar()
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
        }
    }

    func createTabBar() -> UITabBarController {
        TabBarViewController()
    }
}
