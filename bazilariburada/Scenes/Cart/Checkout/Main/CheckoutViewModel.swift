//
//  CheckoutViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation

final class CheckoutViewModel {

    private let addressManager = AddressManager.shared
    private let paymentMethodManager = PaymentMethodManager.shared
    private let authenticationManager = AuthenticationManager.shared
    private let orderService: OrderServiceProtocol
    private let cartService: CartServiceProtocol

    let totalPrice: Double

    var selectedAddress: Address? {
        addressManager.getSelectedAddress()
    }

    var selectedPaymentMethod: PaymentMethod? {
        paymentMethodManager.getSelectedMethod()
    }

    init(totalPrice: Double) {
        orderService = OrderService.shared
        cartService = CartService.shared
        self.totalPrice = totalPrice
    }

    func placeOrder(completion: @escaping StatusHandler) {
        Task {
            let response = await orderService
                .placeAnOrder(
                    to: addressManager.getSelectedAddress()?.fullStreetAddress ?? "",
                    with: authenticationManager.accessToken ?? ""
                )
            await cartService.getUserCart(accessToken: authenticationManager.accessToken ?? "")
            completion(response?.status)
        }
    }
}
