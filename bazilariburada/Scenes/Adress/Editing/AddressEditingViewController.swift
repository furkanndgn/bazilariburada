//
//  AddressEditingViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import UIKit
import Combine

final class AddressEditingViewController: BaseViewController {

    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!

    private let viewModel: AddressViewModel
    private let config: EditingScreenConfig
    private var cancellables = Set<AnyCancellable>()

    init(_ viewModel: AddressViewModel, config: EditingScreenConfig) {
        self.viewModel = viewModel
        self.config = config
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(config)
        addSubscribers()
    }

    @objc func updateAddress() {
        let updatedAddress = Address(
            addressName: viewModel.addressName,
            fullName: viewModel.fullName,
            fullStreetAddress: viewModel.fullStreetAddress,
            city: viewModel.city,
            country: viewModel.country
        )
        viewModel.updateAddress(updatedAddress)
        navigationController?.popViewController(animated: true)
    }

    @objc func saveAddress() {
        let address = Address(
            addressName: viewModel.addressName,
            fullName: viewModel.fullName,
            fullStreetAddress: viewModel.fullStreetAddress,
            city: viewModel.city,
            country: viewModel.country
        )
        viewModel.addNewAddress(address)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addressNameChanged(_ sender: Any) {
        viewModel.addressName = addressNameTextField.text ?? ""
    }

    @IBAction func fullNameChanged(_ sender: Any) {
        viewModel.fullName = fullNameTextField.text ?? ""
    }

    @IBAction func addressChanged(_ sender: Any) {
        viewModel.fullStreetAddress = addressTextField.text ?? ""
    }

    @IBAction func cityChanged(_ sender: Any) {
        viewModel.city = cityTextField.text ?? ""
    }

    @IBAction func countryChanged(_ sender: Any) {
        viewModel.country = countryTextField.text ?? ""
    }
}


// MARK: - Setup UI
private extension AddressEditingViewController {
    
    func setupView(_ config: EditingScreenConfig) {
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        contentStack.layer.cornerRadius = 8
        if config == .add {
            configureForAdd()
        } else {
            configureForUpdate()
        }
    }

    func configureForUpdate() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(updateAddress)
        )
        addressNameTextField.text = viewModel.addressToEdit?.addressName
        fullNameTextField.text = viewModel.addressToEdit?.fullName
        addressTextField.text = viewModel.addressToEdit?.fullStreetAddress
        cityTextField.text = viewModel.addressToEdit?.city
        countryTextField.text = viewModel.addressToEdit?.country
    }

    func configureForAdd() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAddress))
    }

    func addSubscribers() {
        viewModel.$isFieldsValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }
            .store(in: &cancellables)
    }
}
