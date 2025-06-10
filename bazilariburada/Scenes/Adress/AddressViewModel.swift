//
//  AddressViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import Foundation
import Combine

final class AddressViewModel {

    private let addressManager = AddressManager.shared

    var addressToEdit: Address?

    @Published var addresses = [Address]()
    @Published var addressName = ""
    @Published var fullName = ""
    @Published var fullStreetAddress = ""
    @Published var city = ""
    @Published var country = ""
    @Published private var isAddressNameValid = false
    @Published private var isFullNameValid = false
    @Published private var isAddressValid = false
    @Published private var isCityValid = false
    @Published private var isCountryValid = false
    @Published private(set) var isFieldsValid = false

    var addressCount: Int {
        addresses.count
    }

    init() {
        addSubscribers()
        addressManager.load()
    }

    func address(at index: Int) -> Address {
        addresses[index]
    }

    func addNewAddress(_ address: Address) {
        addressManager.addNewAddress(address)
    }

    func updateAddress(_ updatedAddress: Address) {
        guard let addressToEdit else { return }
        delete(addressToEdit)
        addNewAddress(updatedAddress)
    }

    func setSelected(at index: Int) {
        addressManager.setSelected(at: index)
    }

    func delete(_ address: Address) {
        addressManager.delete(address)
    }
}


// MARK: - Bindings
private extension AddressViewModel {
    func addSubscribers() {
        addressManager.$addresses
            .assign(to: &$addresses)
        Publishers.CombineLatest3($isAddressNameValid, $isFullNameValid, $isAddressValid)
            .combineLatest($isCityValid, $isCountryValid)
            .map { (group1, city, country) in
                let (addressNameValid, fullNameValid, addressValid) = group1
                return addressNameValid && fullNameValid && addressValid && city && country
            }
            .assign(to: &$isFieldsValid)
        $addressName
            .map { !$0.isTrimmedEmpty }
            .assign(to: &$isAddressNameValid)
        $fullName
            .map { CredentialValidator.validateFullname($0) }
            .assign(to: &$isFullNameValid)
        $fullStreetAddress
            .map { !$0.isTrimmedEmpty }
            .assign(to: &$isAddressValid)
        $city
            .map { !$0.isTrimmedEmpty }
            .assign(to: &$isCityValid)
        $country
            .map { !$0.isTrimmedEmpty }
            .assign(to: &$isCountryValid)
    }
}
