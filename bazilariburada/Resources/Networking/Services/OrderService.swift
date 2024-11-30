//
//  OrderService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

class OrderService {
    private let ordersKeywork = "/orders"
    
    private let networkManager = NetworkManager.shared
    private var orderSubscription: AnyCancellable?
    
    @Published var placedOrder: Order?
    @Published var orderByID: Order?
    @Published var allOrders: [Order]?
    
    func placeAnOrder(token: String) {
        
        orderSubscription = networkManager.performRequest(endpoint: "\(ordersKeywork)", method: .POST, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.placedOrder = response.data
                self?.orderSubscription?.cancel()
            })
    }
    
    func getUsersOrderByID(token: String, orderID: String) {
        
        orderSubscription = networkManager.performRequest(endpoint: "\(ordersKeywork)/\(orderID)", method: .GET)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.orderByID = response.data
                self?.orderSubscription?.cancel()
            })
    }
    
    func getUsersAllOrders(token: String) {
        
        orderSubscription = networkManager.performRequest(endpoint: "\(ordersKeywork)", method: .GET, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.allOrders = response.data
                self?.orderSubscription?.cancel()
            })
    }
}
    
