//
//  HomeRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.05.2025.
//

import UIKit

final class HomeRouter {

    static let shared = HomeRouter()

    private init() {}

    func initialScreen() -> UINavigationController {
        let viewController = createHomeScreen()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "shop",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        return navigationController
    }
}


// MARK: - Setup Routing
private extension HomeRouter {

    func createHomeScreen() -> UIViewController {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel)
        viewController.onRoute = { 
            switch $0 {
            case .toProductDetail(let sender, let product):
                self.pushProductDetailScreen(for: product, sender)
            }
        }
        return viewController
    }

    func pushProductDetailScreen(for product: Product, _ sender: UIViewController) {
        let router = ProductDetailRouter.shared
        let viewController = router.createProductDetailScreen(for: product)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
