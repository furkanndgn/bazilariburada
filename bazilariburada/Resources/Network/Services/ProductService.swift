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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allProducts: AllProductResponseData?
    @Published var productByID: Product?
    
    func getAllProduct() {
        networkManager.request(endpoint: "\(productsKeyword)", method: .GET)
            .decode(type: ApiResponse<AllProductResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.allProducts = response.data
            })
            .store(in: &cancellables)
    }
    
    func getProductByID(productID: String) {
        networkManager.request(endpoint: "\(productsKeyword)/\(productID)", method: .GET)
            .decode(type: ApiResponse<Product>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.productByID = response.data
            })
            .store(in: &cancellables)
    }
}
