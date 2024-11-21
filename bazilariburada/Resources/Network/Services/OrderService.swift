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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var placedOrder: Order?
    @Published var orderByID: Order?
    @Published var allOrders: [Order]?
    
    func placeAnOrder(token: String) {
        networkManager.request(endpoint: "\(ordersKeywork)", method: .POST, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<Order>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.placedOrder = response.data
            })
            .store(in: &cancellables)
    }
    
    func getUsersOrderByID(token: String, orderID: String) {
        networkManager.request(endpoint: "\(ordersKeywork)/\(orderID)", method: .GET)
            .decode(type: ApiResponse<Order>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.orderByID = response.data
            })
            .store(in: &cancellables)
    }
    
    func getUsersAllOrders(token: String) {
        networkManager.request(endpoint: "\(ordersKeywork)", method: .GET, requiresAuthentication: true, token: token)
            .decode(type: ApiResponse<[Order]>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.allOrders = response.data
            })
            .store(in: &cancellables)
    }
}
    
