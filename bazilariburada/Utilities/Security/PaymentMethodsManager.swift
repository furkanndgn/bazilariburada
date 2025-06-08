//
//  PaymentMethodsManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 6.06.2025.
//

import Foundation

final class PaymentMethodsManager {

    static let shared = PaymentMethodsManager()

    private let keychainManager = KeychainManager.shared
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let account = Constants.Keychain.paymentAccount

    @Published var paymentMethods = [PaymentMethod]()

    private init() {}

    func addNewPaymentMethod(_ paymentMethod: PaymentMethod) {
        paymentMethods.append(paymentMethod)
        save()
    }

    func getSelectedMethod() -> PaymentMethod? {
        load()
        return paymentMethods.first(where: { $0.isSelected })
    }

    func setSelected(at index: Int) {
        for i in paymentMethods.indices {
            paymentMethods[i].isSelected = false
        }
        paymentMethods[index].isSelected = true
        save()
    }

    func delete(_ paymentMethod: PaymentMethod) {
        let wasSelected = paymentMethod.isSelected
        paymentMethods.removeAll { $0.id == paymentMethod.id }
        if wasSelected, !paymentMethods.isEmpty {
            setSelected(at: 0)
        }
        save()
    }

    func load() {
        do {
            paymentMethods = try keychainManager.load(service: serviceIdentifier, account: account) ?? []
            if paymentMethods.count == 1 && paymentMethods.first?.isSelected == false {
                setSelected(at: 0)
            }
        } catch let error {
            print(error)
        }
    }

    private func save() {
        do {
            try keychainManager.save(paymentMethods, service: serviceIdentifier, account: account)
        } catch let error {
            print(error)
        }
    }
}
