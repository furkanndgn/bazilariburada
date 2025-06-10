//
//  AddressManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import Foundation

final class AddressManager {

    static let shared = AddressManager()

    private let keychainManager = KeychainManager.shared
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let account = Constants.Keychain.addressAccount

    @Published var addresses = [Address]()

    private init() {}

    func addNewAddress(_ address: Address) {
        addresses.append(address)
        save()
    }

    func getSelectedAddress() -> Address? {
        load()
        return addresses.first(where: { $0.isSelected })
    }

    func setSelected(at index: Int) {
        for i in addresses.indices {
            addresses[i].isSelected = false
        }
        addresses[index].isSelected = true
        save()
    }

    func delete(_ address: Address) {
        let wasSelected = address.isSelected
        addresses.removeAll { $0.id == address.id }
        if wasSelected, !addresses.isEmpty {
            setSelected(at: 0)
        }
        save()
    }

    func load() {
        do {
            addresses = try keychainManager.load(service: serviceIdentifier, account: account) ?? []
            if addresses.count == 1 && addresses.first?.isSelected == false {
                setSelected(at: 0)
            }
        } catch let error {
            print(error)
        }
    }

    private func save() {
        do {
            try keychainManager.save(addresses, service: serviceIdentifier, account: account)
        } catch let error {
            print(error)
        }
    }
}
