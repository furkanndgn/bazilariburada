//
//  CartServices.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation
import Combine

class CartService {
    private let cartKeyword = "/cart"
    
    private let networkManager = NetworkManager.shared
    private var cartSubscription: AnyCancellable?
    
    @Published var cart: Cart?
    
    func getUsersCart(token: String) {
        
        cartSubscription = networkManager.performRequest(endpoint: "\(cartKeyword)", method: .GET, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.cart = response.data
                self?.cartSubscription?.cancel()
            })
    }
    
    func addItemToCart(token: String, productID: String, quantity: Int) {
        let body = ["productId": productID, "quantity": quantity] as [String : Any]
        
        cartSubscription = networkManager.performRequest(endpoint: "\(cartKeyword)", method: .POST, body: body, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.cart = response.data
                self?.cartSubscription?.cancel()
            })
    }
    
    func updateCartItemQuantity(token: String, productID: String, quantity: Int) {
        let body = ["quantity": quantity]
        
        cartSubscription = networkManager.performRequest(endpoint: "\(cartKeyword)/\(productID)", method: .PATCH, body: body, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.cart = response.data
                self?.cartSubscription?.cancel()
            })
    }
    
    func removeItemFromCart(token: String, productID: String) {
        
        cartSubscription = networkManager.performRequest(endpoint: "\(cartKeyword)/\(productID)", method: .DELETE, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.cart = response.data
                self?.cartSubscription?.cancel()
            })
    }
    
    func clearCartItems(token: String) {
        
        cartSubscription = networkManager.performRequest(endpoint: "\(cartKeyword)", method: .DELETE, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.cart = response.data
                self?.cartSubscription?.cancel()
            })
    }
}
