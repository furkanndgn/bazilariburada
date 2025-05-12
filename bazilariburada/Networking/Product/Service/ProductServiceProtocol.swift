//
//  ProductServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol ProductServiceProtocol {

    var allProductsPublisher: AnyPublisher<APIResponse<AllProductsResponse>?, Never> { get }

    func getAllProducts() async
    func getProduct(by productID: String) async -> Product?
}
