//
//  ProductDetailRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.05.2025.
//

import UIKit

final class ProductDetailRouter {

    func createProductDetailScreen(for product: Product) -> UIViewController {
        let viewModel = ProductDetailViewModel(product)
        let viewController = ProductDetailViewController(viewModel)
        viewController.onRoute = {
            switch $0 {
            case .toReviewScene(let sender):
                self.pushReviewScreen(sender, for: product)
            }
        }
        return viewController
    }
}

private extension ProductDetailRouter {

    func pushReviewScreen(_ sender: UIViewController, for product: Product) {
        let viewModel = ReviewsViewModel(product: product)
        let viewController = ProductReviewsViewController(viewModel: viewModel)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
