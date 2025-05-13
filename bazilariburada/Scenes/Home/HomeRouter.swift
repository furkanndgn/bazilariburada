//
//  HomeRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.05.2025.
//

import UIKit

final class HomeRouter {

    func initialScreen() -> UINavigationController {
        let viewController = createHomeScreen()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        return navigationController
    }
}


private extension HomeRouter {

    func createHomeScreen() -> UIViewController {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel)
        viewController.onRoute = {
            switch $0 {
            case .toProductDetail(let sender, let product):
                self.createProductDetailScreen(sender, for: product)
            }
        }
        return viewController
    }

    func createProductDetailScreen(_ sender: UIViewController, for product: Product) {
        let productDetailRouter = ProductDetailRouter()
        let viewController = productDetailRouter.createProductDetailScreen(for: product)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
