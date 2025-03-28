//
//  MainScreenViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
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
    }
    
    func product(by index: Int) -> Product {
        return allProducts![index]
    }
    
    private func addSubscribers() {
    }
}
