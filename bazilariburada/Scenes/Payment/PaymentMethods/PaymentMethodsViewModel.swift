//
//  PaymentMethodsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import Foundation
import Combine

final class PaymentMethodsViewModel {

    private let keychainManager = KeychainManager.shared
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let account = Constants.Keychain.paymentAccount

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
        paymentMethods.count
    }

    init() {
        addSubscribers()
        load()
    }

    func addNewPaymentMethod(_ paymentMethod: PaymentMethod) {
        paymentMethods.append(paymentMethod)
        save()
        load()
    }

    func paymentMethod(at index: Int) -> PaymentMethod {
        paymentMethods[index]
    }

    func setSelected(at index: Int) {
        for i in paymentMethods.indices {
            paymentMethods[i].isSelected = false
        }
        paymentMethods[index].isSelected = true
        save()
        load()
    }

    func delete(_ paymentMethod: PaymentMethod) {
        let wasSelected = paymentMethod.isSelected
        paymentMethods.removeAll { $0.id == paymentMethod.id }
        if wasSelected, !paymentMethods.isEmpty {
            for i in paymentMethods.indices {
                paymentMethods[i].isSelected = false
            }
            paymentMethods[0].isSelected = true
        }
        save()
        load()
    }

    private func addSubscribers() {
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

    private func save() {
        do {
            try keychainManager.save(paymentMethods, service: serviceIdentifier, account: account)
        } catch let error {
            print(error)
        }
    }

    private func load() {
        do {
            paymentMethods = try keychainManager.load(service: serviceIdentifier, account: account) ?? []
            if paymentMethods.count == 1 && paymentMethods.first?.isSelected == false {
                setSelected(at: 0)
            }
        } catch let error {
            print(error)
        }
    }
}
