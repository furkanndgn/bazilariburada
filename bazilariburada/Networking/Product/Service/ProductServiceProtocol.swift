//
//  ProductServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol ProductServiceProtocol {

    var allProductsPublisher: AnyPublisher<Result<AllProductsResponse, NetworkError>, Never> { get }

    func getAllProducts()
    func getProduct(by productID: String, completion: @escaping (Result<Product, NetworkError>) -> Void)
}
