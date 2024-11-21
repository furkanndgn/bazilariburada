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
    private var cancellables = Set<AnyCancellable>()
    @Published var cart: Cart?
    
    func getUsersCart(token: String) {
        networkManager.request(endpoint: "\(cartKeyword)", method: .GET, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<Cart>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.cart = response.data
            })
            .store(in: &cancellables)
    }
    
    func addItemToCart(token: String, productID: String, quantity: Int) {
        let body = ["productId": productID, "quantity": quantity] as [String : Any]
        networkManager.request(endpoint: "\(cartKeyword)", method: .POST, body: body, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<Cart>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.cart = response.data
            })
            .store(in: &cancellables)
    }
    
    func updateCartItemQuantity(token: String, productID: String, quantity: Int) {
        let body = ["quantity": quantity]
        networkManager.request(endpoint: "\(cartKeyword)/\(productID)", method: .PATCH, body: body, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<Cart>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.cart = response.data
            })
            .store(in: &cancellables)
    }
    
    func removeItemFromCart(token: String, productID: String) {
        networkManager.request(endpoint: "\(cartKeyword)/\(productID)", method: .DELETE, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<Cart>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.cart = response.data
            })
            .store(in: &cancellables)
    }
}
