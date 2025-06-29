//
//  PaymentMethodsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation
import Combine

final class PaymentMethodsViewModel {

    private let paymentMethodManager = PaymentMethodManager.shared

    @Published var paymentMethods = [PaymentMethod]()
    @Published var name = ""
    @Published var number = ""
    @Published var securityCode = ""
    @Published private var isNameValid = false
    @Published private var isNumberValid = false
    @Published private var isSecurityCodeValid = false
    @Published private(set) var isFieldsValid = false

    let months = Array(1...12)
    let monthNames = Calendar.current.monthSymbols

    var years: [Int] {
        let currentYear = Calendar.current.component(.year, from: .now)
        return Array(currentYear...currentYear + 10)
    }

    var methodCount: Int {
        paymentMethods.count
    }

    init() {
        addSubscribers()
        paymentMethodManager.load()
    }

    func paymentMethod(at index: Int) -> PaymentMethod {
        paymentMethods[index]
    }

    func addNewPaymentMethod(_ paymentMethod: PaymentMethod) {
        paymentMethodManager.addNewPaymentMethod(paymentMethod)
    }

    func setSelected(at index: Int) {
        paymentMethodManager.setSelected(at: index)
    }

    func getSelectedMethod() -> PaymentMethod? {
        paymentMethodManager.getSelectedMethod()
    }

    func delete(_ paymentMethod: PaymentMethod) {
        paymentMethodManager.delete(paymentMethod)
    }


}


// MARK: - Set bindings
private extension PaymentMethodsViewModel {
    func addSubscribers() {
        paymentMethodManager.$paymentMethods
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
