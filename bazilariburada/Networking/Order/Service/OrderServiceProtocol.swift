//
//  OrderServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation
import Combine

protocol OrderServiceProtocol {

    var allOrdersPublisher: AnyPublisher<Result<[Order], NetworkError>, NetworkError> { get }

    func placeAnOrder(
        to address: String,
        with accessToken: String,
        completion: @escaping (Result<Order, NetworkError>) -> Void
    )

    func getUserOrder(
        by orderID: String,
        with accessToken: String,
        completion: @escaping (Result<Order, NetworkError>) -> Void
    )

    func getAllOrders(with accessToken: String)
}
