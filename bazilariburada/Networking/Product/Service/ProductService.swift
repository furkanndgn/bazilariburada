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

    private let allProductsSubject = PassthroughSubject<APIResponse<AllProductsResponse>?, Never>()

    var allProductsPublisher: AnyPublisher<APIResponse<AllProductsResponse>?, Never> {
        allProductsSubject.eraseToAnyPublisher()
    }

    func getAllProducts() async {
        do {
            let response: APIResponse<AllProductsResponse> = try await networkManager.performRequest(
                endpoint: ProductEndpoint.getAllProducts())
            allProductsSubject.send(response)
        } catch let error {
            print(error)
        }
    }

    func getProduct(by productID: String) async -> Product? {
        var product: Product?
        do {
            let response: APIResponse<Product> = try await networkManager.performRequest(
                endpoint: ProductEndpoint.getProduct(productID: productID)
            )
            product = response.data
        } catch let error {
            print(error)
        }
        return product
    }
}
