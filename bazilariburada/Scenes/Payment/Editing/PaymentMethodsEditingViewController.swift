//
//  PaymentMethodsEditingViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import UIKit
import Combine

final class PaymentMethodsEditingViewController: BaseViewController {

    private let viewModel: PaymentMethodsViewModel

    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak var expiryDatePicker: UIPickerView!

    private var cancellables = Set<AnyCancellable>()

    private var selectedMonth: Int {
        viewModel.months[expiryDatePicker.selectedRow(inComponent: 0)]
    }

    private var selectedYear: Int {
        viewModel.years[expiryDatePicker.selectedRow(inComponent: 1)]
    }

    init(_ viewModel: PaymentMethodsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubscribers()
    }

    @objc func save() {
        let newMethod = PaymentMethod(
            brand: PaymentProvider.detectCardBrand(numberTextField.text ?? ""),
            number: numberTextField.text ?? "",
            expireMonth: selectedMonth,
            expireYear: selectedYear,
            securityCode: securityCodeTextField.text ?? ""
        )
        viewModel.addNewPaymentMethod(newMethod)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func nameChanged(_ sender: Any) {
        viewModel.name = nameTextField.text ?? ""
    }

    @IBAction func numberChanged(_ sender: Any) {
        viewModel.number = numberTextField.text ?? ""
    }

    @IBAction func securityCodeChanged(_ sender: Any) {
        viewModel.securityCode = securityCodeTextField.text ?? ""
    }
}


// MARK: - Setup UI
private extension PaymentMethodsEditingViewController {

    func setupView() {
        if #available(iOS 17.0, *) {
            nameTextField.textContentType = .creditCardName
            numberTextField.textContentType = .creditCardNumber
            securityCodeTextField.textContentType = .creditCardSecurityCode
        }
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        contentStack.layer.cornerRadius = 8
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = addButton
        expiryDatePicker.delegate = self
        expiryDatePicker.dataSource = self
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


// MARK: - PickerView delegation
extension PaymentMethodsEditingViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? viewModel.months.count : viewModel.years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            let year = viewModel.years[row]
                let lastTwo = String(format: "%02d", year % 100)
                return lastTwo
            } else {
                return viewModel.monthNames[row]
            }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 150
        } else {
            return 60
        }
    }
}
