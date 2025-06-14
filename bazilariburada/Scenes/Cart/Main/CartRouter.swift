//
//  CartRouter.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 29.05.2025.
//

import Foundation

final class CartRouter {

    static let shared = CartRouter()

    private init() {}

    func createCartScreen() -> BaseViewController {
        let viewModel = CartViewModel()
        let viewController = CartViewController(viewModel)
        viewController.onRoute = {
            switch $0 {
            case .toProductDetail(let sender, let product):
                self.pushProductDetailScreen(sender, for: product)
            }
        }
        return viewController
    }
}


private extension CartRouter {
    func pushProductDetailScreen(_ sender: BaseViewController, for product: Product) {
        Task { @MainActor in
            let viewController = ProductDetailRouter.shared.createProductDetailScreen(for: product)
            sender.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
