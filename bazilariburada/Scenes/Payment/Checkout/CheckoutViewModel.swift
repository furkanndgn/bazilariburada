//
//  CheckoutViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation

final class CheckoutViewModel {

    let totalPrice: Double
    private let paymentMethodsManager = PaymentMethodsManager.shared
    private(set) var selectedAddress: Address?

    var selectedPaymentMethod: PaymentMethod? {
        paymentMethodsManager.getSelectedMethod()
    }

    init(totalPrice: Double) {
        self.totalPrice = totalPrice
    }

    func changeAddress(_ address: Address) {
        selectedAddress = address
    }
}
