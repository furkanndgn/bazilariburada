//
//  ProductDetailViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.12.2024.
//

import Foundation
import Combine

final class ProductDetailViewModel: ObservableObject {
    
    private let cartService: CartServiceProtocol
    let product: Product

    var cancellables = Set<AnyCancellable>()

    private var accessToken: String {
        AuthenticationManager.shared.accessToken ?? ""
    }

    var onCartUpdate: Completion?

    init(_ product: Product, cartService: CartServiceProtocol = CartService()) {
        self.product = product
        self.cartService = cartService
        addSubscribers()
    }

    func addToCart(quantity: Int) async {
        await cartService.addToCart(productID: product.id, quantity: quantity, accessToken: accessToken)
    }
}


// MARK: - Setup subscriptions
private extension ProductDetailViewModel {
    func addSubscribers() {
        cartService.currentCartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.onCartUpdate?()
            }
            .store(in: &cancellables)
    }
}
