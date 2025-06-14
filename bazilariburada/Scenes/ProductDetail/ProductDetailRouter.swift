//
//  ProductDetailRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.05.2025.
//

import UIKit

final class ProductDetailRouter {

    static let shared = ProductDetailRouter()

    private init() {}

    func createProductDetailScreen(for product: Product) -> UIViewController {
        let viewModel = ProductDetailViewModel(product)
        let viewController = ProductDetailViewController(viewModel)
        viewController.onRoute = { 
            switch $0 {
            case .toReviewScene(let sender):
                self.pushReviewScreen(for: product, sender)
            }
        }
        return viewController
    }
}


// MARK: - Setup Routing
private extension ProductDetailRouter {

    func pushReviewScreen(for product: Product, _ sender: UIViewController) {
        let viewModel = ReviewsViewModel(product: product)
        let viewController = ProductReviewsViewController(viewModel: viewModel)
        sender.navigationController?.pushViewController(viewController, animated: true)
    }
}
