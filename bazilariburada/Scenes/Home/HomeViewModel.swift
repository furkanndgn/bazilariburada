//
//  MainScreenViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    private let productService: ProductServiceProtocol
    var cancellables = Set<AnyCancellable>()
    @Published var allProducts: [Product]?
    @Published var productByID: Product?
    var productCount: Int? {
        allProducts?.count
    }

    init(productService: ProductServiceProtocol = ProductService()) {
        self.productService = productService
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
    
    private func addSubscribers() {
        productService.allProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.allProducts = response?.data?.products
            }
            .store(in: &cancellables)
    }
}
