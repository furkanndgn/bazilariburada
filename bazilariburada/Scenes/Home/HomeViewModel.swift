//
//  HomeViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    private let productService: ProductServiceProtocol
    private let cartService: CartServiceProtocol
    private let authenticationManager: AuthenticationManager
    private var cancellables = Set<AnyCancellable>()

    private var accessToken = ""

    @Published var allProducts: [Product]?
    @Published var productByID: Product?

    var productCount: Int? {
        allProducts?.count
    }

    var onCartUpdate: Completion?

    init(
        productService: ProductServiceProtocol = ProductService(),
        cartService: CartServiceProtocol = CartService.shared,
        authenticationManager: AuthenticationManager = .shared
    ) {
        self.productService = productService
        self.cartService = cartService
        self.authenticationManager = authenticationManager
        addSubscribers()
    }

    func getProducts() async {
        await productService.getAllProducts()
    }

    func getProductByID(productID: String) {

    }

    func product(by index: Int) -> Product {
        return allProducts![index]
    }

    func addToCart(by id: String) async {
        accessToken = await authenticationManager.accessToken ?? ""
        await cartService.addToCart(productID: id, quantity: 1, accessToken: accessToken)
    }

    func getCurrentCart() async {
        accessToken = await authenticationManager.accessToken ?? ""
        await cartService.getUserCart(accessToken: accessToken)
    }
}


// MARK: - Setup subscriptions
private extension HomeViewModel {
    func addSubscribers() {
        productService.allProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.allProducts = response?.data?.products
            }
            .store(in: &cancellables)
        cartService.currentCartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.onCartUpdate?()
            }
            .store(in: &cancellables)
    }
}
