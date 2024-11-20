//
//  CartServices.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.11.2024.
//

import Foundation
import Combine

class CartService {
    let cartKeyword = "/cart"
    
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var cart: Cart?
    
    func getUserCart(token: String) {
        networkManager.request(endpoint: "\(cartKeyword)", method: .GET, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<Cart>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.cart = response.data
            })
            .store(in: &cancellables)
        
    }
}
