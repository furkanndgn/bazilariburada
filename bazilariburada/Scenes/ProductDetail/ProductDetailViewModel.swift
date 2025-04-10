//
//  ProductDetailViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.12.2024.
//

import Foundation
import Combine

final class ProductDetailViewModel: ObservableObject {
    
    let cartService: CartService
    let product: Product
    var cancellables = Set<AnyCancellable>()
    
    init(product: Product) {
        self.product = product
        cartService = CartService()
    }
    
    
    func addToCart() {
    }
}
