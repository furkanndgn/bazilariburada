//
//  TabBarViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.viewControllers = [
            createHomeScreen(),
            createCartScreen(),
            createWishlistScreen()
        ]
        NotificationCenter.default.addObserver(forName: .checkoutDidFinish, object: nil, queue: .main) { [weak self] _ in
            self?.selectedIndex = 0
        }
    }
}


private extension MainTabBarController {

    func createHomeScreen() -> UINavigationController {
        HomeRouter.shared.initialScreen()
    }

    func createCartScreen() -> UINavigationController {
        let cartScreen =  CartRouter.shared.createCartScreen()
        let navigationController = UINavigationController(rootViewController: cartScreen)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        return navigationController
    }

    func createWishlistScreen() -> UINavigationController {
        let wishlistScreen = WishlistRouter.shared.createWishlistScreen()
        let navigationController = UINavigationController(rootViewController: wishlistScreen)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        return navigationController
    }
}
