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
    private let wishlistService: WishlistServiceProtocol
    let product: Product

    @Published var isInWishlist: Bool = false

    var cancellables = Set<AnyCancellable>()

    private var accessToken = ""

    var onCartUpdate: Completion?

    init(
        _ product: Product,
        cartService: CartServiceProtocol = CartService.shared,
        wishlistService: WishlistServiceProtocol = WishlistService.shared
    ) {
        self.product = product
        self.cartService = cartService
        self.wishlistService = wishlistService
        addSubscribers()
        Task {
            await getWishlist()
        }
    }

    func addToCart(quantity: Int) async {
        accessToken = await AuthenticationManager.shared.accessToken ?? ""
        await cartService.addToCart(productID: product.id, quantity: quantity, accessToken: accessToken)
    }

    func addToWishlist() async {
        accessToken = await AuthenticationManager.shared.accessToken ?? ""
        await wishlistService.addItemToWishlist(product.id, with: accessToken)
    }

    func removeFromWishlist() async {
        accessToken = await AuthenticationManager.shared.accessToken ?? ""
        await wishlistService.removeFromWishlist(productID: product.id, with: accessToken)
    }

    private func getWishlist() async {
        accessToken = await AuthenticationManager.shared.accessToken ?? ""
        await wishlistService.getUserWishlist(with: accessToken)
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
        wishlistService.wishlistPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wishlist in
                guard let self, let wishlist = wishlist?.wishlist else {
                    self?.isInWishlist = false
                    return
                }
                self.isInWishlist = wishlist.contains(where: { $0.id == self.product.id })
            }
            .store(in: &cancellables)
    }
}
