//
//  UserOrdersViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.06.2025.
//

import Foundation
import Combine

final class UserOrdersViewModel {

    private let orderService: OrderServiceProtocol
    private let authenticationManager = AuthenticationManager.shared
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var userOrders = [Order]()

    var orderCount: Int {
        userOrders.count
    }

    init() {
        self.orderService = OrderService.shared
        addSubscribers()
    }

    func order(at index: Int) -> Order {
        userOrders[index]
    }

    func getUserOrders() async {
        await orderService.getAllOrders(with: authenticationManager.accessToken ?? "")
    }
}


// MARK: - Setup Bindings
private extension UserOrdersViewModel {

    func addSubscribers() {
        orderService.userOrdersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                guard let userOrders = orders else { return }
                self?.userOrders = userOrders
            }
            .store(in: &cancellables)
    }
}
