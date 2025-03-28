//
//  ProductService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

/// For endpoints in `Product` collection
final class ProductService: ProductServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    private let allProductsSubject = PassthroughSubject<Result<AllProductsResponse, NetworkError>, Never>()

    var allProductsPublisher: AnyPublisher<Result<AllProductsResponse, NetworkError>, Never> {
        allProductsSubject.eraseToAnyPublisher()
    }

    func getAllProducts() {
        networkManager
            .performRequest(
                endpoint: ProductEndpoint.getAllProducts(),
                responseType: AllProductsResponse.self
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.allProductsSubject.send(.success(data))
                    }
                case .failure(let networkError):
                    self.allProductsSubject.send(.failure(networkError))
                }
            }
    }

    func getProduct(by productID: String, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        networkManager
            .performRequest(
                endpoint: ProductEndpoint.getProduct(productID: productID),
                responseType: Product.self
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        completion(.success(data))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
}
