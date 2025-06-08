//
//  CartViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.05.2025.
//

import Foundation
import Combine

final class CartViewModel: ObservableObject {

    private let cartService: CartServiceProtocol
    private let productService: ProductServiceProtocol
    private let authenticationManager: AuthenticationManager
    var cancellables = Set<AnyCancellable>()


    private var cartQuantityUpdateInProgress: Bool = false

    @Published private var currentCart: Cart?
    @Published private(set) var cartDisplayItems = [CartDisplayModel]()

    var productCount: Int {
        cartDisplayItems.count
    }

    var totalPrice: Double {
        currentCart?.totalPrice ?? 0
    }

    init(
        cartService: CartServiceProtocol = CartService.shared,
        productService: ProductServiceProtocol = ProductService(),
        authenticationManager: AuthenticationManager = .shared
    ) {
        self.cartService = cartService
        self.productService = productService
        self.authenticationManager = authenticationManager
        addSubscribers()
    }

    func product(by index: Int) -> CartDisplayModel {
        return cartDisplayItems[index]
    }

    func getCurrentCart() async {
        await cartService.getUserCart(accessToken: authenticationManager.accessToken ?? "")
    }

    func updateItemQuantity(_ id: String, quantity: Int) async {
        guard !cartQuantityUpdateInProgress else { return }
        cartQuantityUpdateInProgress = true
        await cartService.updateQuantity(of: id, with: quantity, accessToken: authenticationManager.accessToken ?? "")
        cartQuantityUpdateInProgress = false
    }

    func removeItemFromCart(_ id: String) async {
        await cartService.removeFromCart(productID: id, accessToken: authenticationManager.accessToken ?? "")
    }
}


private extension CartViewModel {
    func addSubscribers() {
        cartService.currentCartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cart in
                guard let self else { return }
                if self.cartQuantityUpdateInProgress {
                    self.currentCart = cart
                }
                if self.currentCart != cart {
                    self.currentCart = cart
                    Task { await self.enrichCartItems() }
                }
            }
            .store(in: &cancellables)
    }

    func enrichCartItems() async {
        guard let cart = currentCart else { return }
        let items: [CartDisplayModel] = await withTaskGroup(of: (Int, CartDisplayModel?).self) { [weak self] group in
            for (index, cartItem) in cart.cartItems.enumerated() {
                group.addTask {
                    guard let product = await self?.productService.getProduct(by: cartItem.productID) else { return (index, nil) }
                    return (index, CartDisplayModel(cartItem: cartItem, product: product))
                }
            }
            var loaded = [(Int, CartDisplayModel)]()
            for await (index, item) in group {
                if let item = item { loaded.append((index, item)) }
            }
            return loaded.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
        cartDisplayItems = items
    }
}
