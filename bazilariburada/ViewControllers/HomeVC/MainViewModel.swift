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
        productService.getProductByID(productID: productID)
    }
    
    func product(by index: Int) -> Product {
        print(allProducts![index])
        return allProducts![index]
    }
    
    private func addSubscribers() {
        productService.$allProducts
            .sink { [weak self] returnedProducts in
                self?.allProducts = returnedProducts?.products
                self?.productCount = returnedProducts?.totalProducts
                print("product count: \(self?.productCount ?? 0)")
            }
            .store(in: &cancellables)
        
        productService.$productByID
            .sink { [weak self] returnedProduct in
                self?.productByID = returnedProduct
            }
            .store(in: &cancellables)
    }
}
