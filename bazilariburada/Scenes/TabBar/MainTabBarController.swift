//
//  TabBarViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {

    let productDetailRouter: ProductDetailRouter
    let homeRouter: HomeRouter
    let cartRouter: CartRouter

    init(
        productDetailRouter: ProductDetailRouter = ProductDetailRouter(),
        homeRouter: HomeRouter = HomeRouter(),
        cartRouter: CartRouter = CartRouter()
    ) {
        self.productDetailRouter = productDetailRouter
        self.homeRouter = homeRouter
        self.cartRouter = cartRouter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.viewControllers = [
            createHomeScreen(),
            createProfileScreen(),
            createReviewScreen(),
            createCartScreen()
        ]
    }
}


private extension MainTabBarController {

    func createHomeScreen() -> UINavigationController {
            homeRouter.initialScreen()
    }

    func createProfileScreen() -> UINavigationController{
        let profileScreen = LoginViewController(LoginViewModel())
        let navigationController = UINavigationController(rootViewController: profileScreen)
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 1)
        return navigationController
    }

    func createCartScreen() -> UINavigationController {
        let cartScreen = cartRouter.createCartScreen()
        let navigationController = UINavigationController(rootViewController: cartScreen)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 4)
        return navigationController
    }
}

//    MARK: - Testing
private extension MainTabBarController {

    func createReviewScreen() -> UINavigationController {
        let reviewScreen = ProductReviewsViewController(viewModel: ReviewsViewModel(product: Product.sample))
        let navigationController = UINavigationController(rootViewController: reviewScreen)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        return navigationController
    }
}
