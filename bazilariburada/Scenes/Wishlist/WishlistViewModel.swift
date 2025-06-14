//
//  WishlistViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.06.2025.
//

import Foundation
import Combine

final class WishlistViewModel {

    private let wishlistService: WishlistServiceProtocol
    private let cartService: CartServiceProtocol
    private let productService: ProductServiceProtocol
    private let authenticationManager = AuthenticationManager.shared
    var cancellables = Set<AnyCancellable>()

    @Published private(set) var currentWishlist = [WishlistItem]()

    var productCount: Int {
        currentWishlist.count
    }

    var onAddToCart: Completion?

    init(
        wishlistService: WishlistServiceProtocol = WishlistService.shared,
        cartService: CartServiceProtocol = CartService.shared,
        productService: ProductServiceProtocol = ProductService()
    ) {
        self.wishlistService = wishlistService
        self.cartService = cartService
        self.productService = productService
        addSubscribers()
    }

    func wishlistItem(at index: Int) -> WishlistItem {
        return currentWishlist[index]
    }

    func getCurrentWishlist() async {
        await wishlistService.getUserWishlist(with: authenticationManager.accessToken ?? "")
    }

    func removeFromWishlist(_ id: String) async {
        await wishlistService.removeFromWishlist(productID: id, with: authenticationManager.accessToken ?? "")
    }

    func addItemToCart(_ id: String) async {
        await cartService.addToCart(productID: id, quantity: 1, accessToken: authenticationManager.accessToken ?? "")
        await removeFromWishlist(id)
        onAddToCart?()
    }

    func getProductDetail(_ id: String) async -> Product? {
        await productService.getProduct(by: id)
    }
}


// MARK: - Setup bindings
private extension WishlistViewModel {

    func addSubscribers() {
        wishlistService.wishlistPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wishlist in
                self?.currentWishlist = wishlist?.wishlist ?? []
                self?.onAddToCart?()
            }
            .store(in: &cancellables)
    }
}
