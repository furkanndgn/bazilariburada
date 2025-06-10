//
//  AddressEditingViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import UIKit
import Combine

final class AddressEditingViewController: BaseViewController {

    private let viewModel: AddressViewModel
    private let config: EditingScreenConfig

    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!

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
}


// MARK: - Setup UI
private extension AddressEditingViewController {
    func setupView(_ config: EditingScreenConfig) {
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        contentStack.layer.cornerRadius = 8
        var button: UIBarButtonItem?
        if config == .add {
            button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveAddress))
        } else {
            button = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(updateAddress)
            )
        }
        guard let button else { return }
        navigationItem.rightBarButtonItem = button
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
