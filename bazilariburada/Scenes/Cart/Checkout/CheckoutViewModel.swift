//
//  CheckoutViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation

final class CheckoutViewModel {

    private let paymentMethodManager = PaymentMethodManager.shared
    private let addressManager = AddressManager.shared

    let totalPrice: Double

    var selectedAddress: Address? {
        addressManager.getSelectedAddress()
    }

    var selectedPaymentMethod: PaymentMethod? {
        paymentMethodManager.getSelectedMethod()
    }

    init(totalPrice: Double) {
        self.totalPrice = totalPrice
    }
}
