//
//  ProductService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

class ProductService {
    private let productsKeyword = "/products"
    
    private let networkManager = NetworkManager.shared
    private var productSubscription: AnyCancellable?
    
    @Published var allProducts: AllProductsResponseData?
    @Published var productByID: Product?
    
    func getAllProducts() {
        
        productSubscription = networkManager.performRequest(endpoint: "\(productsKeyword)", method: .GET)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.allProducts = response.data
                self?.productSubscription?.cancel()
            })
    }
    
    func getProductByID(productID: String) {
        
        productSubscription = networkManager.performRequest(endpoint: "\(productsKeyword)/\(productID)", method: .GET)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.productByID = response.data
                self?.productSubscription?.cancel()
            })
    }
}
