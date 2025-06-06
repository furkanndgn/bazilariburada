//
//  CheckoutViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation

final class CheckoutViewModel {

    private(set) var selectedCard: PaymentMethod?
    private(set) var selectedAddress: Address?

    func changeSelectedCard(with newCard: PaymentMethod) {
        selectedCard = newCard
    }

    func changeAddress(_ address: Address) {
        selectedAddress = address
    }
}
