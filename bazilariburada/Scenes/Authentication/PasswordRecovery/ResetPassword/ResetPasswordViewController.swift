//
//  ResetPasswordViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import UIKit
import Combine

final class ResetPasswordViewController: BaseViewController, RouteEmitting {

    @IBOutlet weak var securityCodeTextField: UnderlinedTextFieldView!
    @IBOutlet weak var passwordTextField: UnderlinedTextFieldView!
    @IBOutlet weak var securityCodeWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var dummyUpdateButton: UIButton!

    private let viewModel: ResetPasswordViewModel
    private var cancellables = Set<AnyCancellable>()

    var onRoute: ((Route) -> Void)?

    init(_ viewModel: ResetPasswordViewModel) {
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

    private func addSubscribers() {
        viewModel.$isUpdateEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.updateButton.isHidden = !isEnabled
                self?.dummyUpdateButton.isHidden = isEnabled
            }
            .store(in: &cancellables)
        viewModel.$isCodeValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                if isValid {
                    self?.securityCodeTextField.makeBorderInvisible()
                    self?.securityCodeWarningLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
        viewModel.$isPasswordValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                if isValid {
                    self?.passwordTextField.makeBorderInvisible()
                    self?.passwordWarningLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }

    @IBAction func updateTapped(_ sender: Any) {
        viewModel.resetPassword { [weak self] statusCode in
            guard let self else { return }
            if statusCode == 200 {
                self.onRoute?(.toLogin(self))
            } else {
                self.showAlert()
            }
        }
    }
    
    @IBAction func dummyUpdateTapped(_ sender: Any) {
        if !viewModel.isCodeValid {
            securityCodeWarningLabel.isHidden = false
            securityCodeTextField.makeBorderVisible(true)
        }
        if !viewModel.isPasswordValid {
            passwordWarningLabel.isHidden = false
            passwordTextField.makeBorderVisible(true)
        }
    }

    @objc func codeChanged(_ sender: UITextField) {
        viewModel.activationCode = sender.text ?? ""
    }

    @objc func passwordChanged(_ sender: UITextField) {
        viewModel.newPassword = sender.text ?? ""
    }
}


// MARK: - Setup UI
private extension ResetPasswordViewController {

    func setupView() {
        setupTextFields()
    }

    func setupTextFields() {
        securityCodeTextField.textField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        securityCodeTextField.textField.delegate = self
        securityCodeTextField.configureView(according: .securityCode)
        passwordTextField.configureView(according: .password)
    }

    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.updateButton.showLoading(loading)
            if loading {
                self?.securityCodeTextField.textField.isUserInteractionEnabled = false
                self?.passwordTextField.textField.isUserInteractionEnabled = false
            } else {
                self?.securityCodeTextField.textField.isUserInteractionEnabled = true
                self?.passwordTextField.textField.isUserInteractionEnabled = true
            }
        }
    }

    func showAlert() {
        let alert = ErrorPopupViewController()
        alert.configurePopup(title: "Something Went Wrong", message: "Please try again.")
        alert.onDismiss = {
            alert.animateOut {
                alert.dismiss(animated: true)
            }
        }
        self.present(alert, animated: false) {
            alert.animateIn()
        }
    }
}


// MARK: - Setup Routing
extension ResetPasswordViewController {
    enum Route {
        case toLogin(BaseViewController)
        case toForgotPassword(BaseViewController)
    }
}


// MARK: - UITextFieldDelegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 6
    }
}
