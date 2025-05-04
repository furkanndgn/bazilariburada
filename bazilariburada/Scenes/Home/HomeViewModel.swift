//
//  MainScreenViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    private let productService: ProductService
    var cancellables = Set<AnyCancellable>()
    @Published var allProducts: [Product]?
    @Published var productByID: Product?
    @Published var productCount: Int?
    
    init(productService: ProductService = ProductService()) {
        self.productService = productService
        addSubscribers()
        getProducts()
    }
    
    func getProducts() {
        productService.getAllProducts()
    }
    
    func getProductByID(productID: String) {
        productService.getProduct(by: productID) { [weak self] result in
            switch result {
            case .success(let product):
                self?.productByID = product
            case .failure(let error):
                print(String(describing: error.errorDescription))
            }
        }
    }
    
    func product(by index: Int) -> Product {
        return allProducts![index]
    }
    
    private func addSubscribers() {
        productService.allProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let data):
                    self?.allProducts = data.products
                    self?.productCount = data.products.count
                case .failure(let error):
                    print(String(describing: error.errorDescription))
                }
            }
            .store(in: &cancellables)
    }
}
