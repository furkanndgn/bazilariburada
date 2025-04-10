//
//  TabBarViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    let homeVC = UINavigationController(rootViewController: MainViewController(nibName: "MainViewController",
                                                                               bundle: nil))
    let signInVC = UINavigationController(rootViewController: SignInViewController())

    let productDetailVC = UINavigationController(
        rootViewController: ProductDetailViewController(viewModel: ProductDetailViewModel(product: Product()))
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        signInVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        productDetailVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)

        self.viewControllers = [homeVC, signInVC, productDetailVC]
    }
}
