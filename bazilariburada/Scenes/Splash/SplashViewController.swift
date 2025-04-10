//
//  SplashViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

class SplashViewController: UIViewController {
    
    let tabBar: UITabBarController
    let viewModel: SplashViewModel
    
    init(tabBar: UITabBarController = TabBarViewController(), viewModel: SplashViewModel = SplashViewModel()) {
        self.tabBar = tabBar
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.transitionToMainApp()
        })
    }
    
    private func transitionToMainApp() {
            guard let scene = view.window?.windowScene else {
                print("No active UIWindowScene found.")
                return
            }
            if let window = scene.windows.first {
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                window.layer.add(transition, forKey: kCATransition)
                window.rootViewController = self.tabBar
                window.makeKeyAndVisible()
    }
        }
}
