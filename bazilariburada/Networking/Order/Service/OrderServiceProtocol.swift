//
//  OrderServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol OrderServiceProtocol {

    static var shared: OrderServiceProtocol { get }

    var allOrdersPublisher: AnyPublisher<[Order]?, Never> { get }

    func placeAnOrder(to address: String, with accessToken: String) async -> APIResponse<Order>?

    func getUserOrder(by orderID: String, with accessToken: String) async -> APIResponse<Order>?

    func getAllOrders(with accessToken: String) async
}
