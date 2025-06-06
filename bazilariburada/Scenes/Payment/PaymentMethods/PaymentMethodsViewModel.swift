//
//  PaymentMethodsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation
import Combine

final class PaymentMethodsViewModel {

    private let paymentMethodsManager = PaymentMethodsManager.shared

    @Published var paymentMethods = [PaymentMethod]()
    @Published var name = ""
    @Published var number = ""
    @Published var securityCode = ""
    @Published private(set) var isNameValid = false
    @Published private(set) var isNumberValid = false
    @Published private(set) var isSecurityCodeValid = false
    @Published private(set) var isFieldsValid = false

    let months = Array(1...12)

    var years: [Int] {
        let currentYear = Calendar.current.component(.year, from: .now)
        return Array(currentYear...currentYear + 10)
    }

    var methodCount: Int {
        paymentMethodsManager.paymentMethods.count
    }

    init() {
        addSubscribers()
        paymentMethodsManager.load()
    }

    func addNewPaymentMethod(_ paymentMethod: PaymentMethod) {
        paymentMethodsManager.addNewPaymentMethod(paymentMethod)
    }

    func paymentMethod(at index: Int) -> PaymentMethod {
        paymentMethodsManager.paymentMethods[index]
    }

    func setSelected(at index: Int) {
        paymentMethodsManager.setSelected(at: index)
    }

    func delete(_ paymentMethod: PaymentMethod) {
        paymentMethodsManager.delete(paymentMethod)
    }

    private func addSubscribers() {
        paymentMethodsManager.$paymentMethods
            .assign(to: &$paymentMethods)
        Publishers.CombineLatest3($isNameValid, $isNumberValid, $isSecurityCodeValid)
            .map { $0 && $1 && $2}
            .assign(to: &$isFieldsValid)
        $name
            .map { CredentialValidator.validateFullname($0) }
            .assign(to: &$isNameValid)
        $number
            .map { CardValidator.luhnCheck($0) }
            .assign(to: &$isNumberValid)
        $securityCode
            .map { [weak self] in CardValidator.cvvCheck($0, brand: PaymentProvider.detectCardBrand(self?.number ?? ""))}
            .assign(to: &$isSecurityCodeValid)
    }
}
