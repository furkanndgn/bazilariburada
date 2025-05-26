//
//  TabBarViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

@MainActor
final class TabBarViewController: UITabBarController {

    let productDetailRouter: ProductDetailRouter
    let homeRouter: HomeRouter

    init(
        productDetailRouter: ProductDetailRouter = ProductDetailRouter(),
        homeRouter: HomeRouter = HomeRouter()
    ) {
        self.productDetailRouter = productDetailRouter
        self.homeRouter = homeRouter
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
            createReviewScreen()
        ]
    }
}

private extension TabBarViewController {

    func createHomeScreen() -> UINavigationController {
            homeRouter.initialScreen()
    }

    func createProfileScreen() -> UINavigationController{
        let profileScreen = LoginViewController(LoginViewModel())
        let navigationController = UINavigationController(rootViewController: profileScreen)
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 1)
        return navigationController
    }
}

//    MARK: - Testing
private extension TabBarViewController {

    func createReviewScreen() -> UINavigationController {
        let reviewScreen = ProductReviewsViewController(viewModel: ReviewsViewModel(product: Product.sample))
        let navigationController = UINavigationController(rootViewController: reviewScreen)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        return navigationController
    }
}
