//
//  ProductDetailViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.12.2024.
//

import Foundation
import Combine

class ProductDetailViewModel: ObservableObject {
    
    let cartService: CartService
    let product: Product
    var cancellables = Set<AnyCancellable>()
     
    @Published var itemQuantity: Int = 1
    
    init(product: Product) {
        self.product = product
        cartService = CartService()
    }
    
    func updateItemQuantity(quantity: Int) {
        itemQuantity = quantity
    }
    
    func addToCart() {
        cartService.addItemToCart(token: "", productID: product.id ?? "", quantity: itemQuantity)
        itemQuantity = 1
    }
}
