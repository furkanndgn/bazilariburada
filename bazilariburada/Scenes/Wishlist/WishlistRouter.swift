//
//  WishlistRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.06.2025.
//

import UIKit

final class WishlistRouter {

    static let shared = WishlistRouter()

    private init() {}

    func createWishlistScreen() -> UIViewController {
        let viewModel = WishlistViewModel()
        let viewController = WishlistViewController(viewModel)
        viewController.onRoute = {
            switch $0 {
            case .toProductDetail(let sender, let product):
                self.pushProductDetailScreen(for: product, sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension WishlistRouter {
    func pushProductDetailScreen(for product: Product, _ sender: BaseViewController) {
        let router = ProductDetailRouter.shared
        let viewController = router.createProductDetailScreen(for: product)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
