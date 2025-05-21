//
//  SignUpViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 13.05.2025.
//

import UIKit
import Combine

final class SignUpViewController: BaseViewController, RouteEmitting {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var routeToLoginButton: UIButton!
    @IBOutlet weak var usernameTextField: UnderlinedTextFieldView!
    @IBOutlet weak var emailTextField: UnderlinedTextFieldView!
    @IBOutlet weak var passwordTextField: UnderlinedTextFieldView!
    @IBOutlet weak var usernameWarningLabel: UILabel!
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    @IBOutlet weak var dummyRegisterButton: UIButton!


    private let viewModel: SignUpViewModel
    private var cancellables = Set<AnyCancellable>()

    var onRoute: ((Route) -> Void)?

    init(_ viewModel: SignUpViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: animated)
    }

    private  func addSubscribers() {
        viewModel.$isRegisterEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.registerButton.isHidden = !isEnabled
                self?.dummyRegisterButton.isHidden = isEnabled
            }
            .store(in: &cancellables)
        viewModel.$isEmailValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                if isValid {
                    self?.emailTextField.makeBorderInvisible()
                    self?.emailWarningLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
        viewModel.$isUsernameValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                if isValid {
                    self?.usernameTextField.makeBorderInvisible()
                    self?.usernameWarningLabel.isHidden = true
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
}


// MARK: - Setup UI
private extension SignUpViewController {
    func setupView() {
        setupTextFields()
    }


    func setupTextFields() {
        emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        emailTextField.configureView(according: .email)
        usernameTextField.textField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        usernameTextField.configureView(according: .username)
        passwordTextField.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        passwordTextField.configureView(according: .password)
    }
}


// MARK: - Activation functions
private extension SignUpViewController {

    @objc func usernameChanged(_ sender: UITextField) {
        viewModel.username = sender.text ?? ""
    }

    @objc func emailChanged(_ sender: UITextField) {
        viewModel.email = sender.text ?? ""
    }

    @objc func passwordChanged(_ sender: UITextField) {
        viewModel.password = sender.text ?? ""
    }

    @IBAction func dummyRegisterButtonTapped(_ sender: UIButton) {
        if !viewModel.isEmailValid {
            emailWarningLabel.isHidden = false
            emailTextField.makeBorderVisible(true)
        }
        if !viewModel.isUsernameValid {
            usernameWarningLabel.isHidden = false
            usernameTextField.makeBorderVisible(true)
        }
        if !viewModel.isPasswordValid {
            passwordWarningLabel.isHidden = false
            passwordTextField.makeBorderVisible(true)
        }
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        viewModel
            .register() { [weak self] statusCode in
                guard let self else { return }
                if statusCode == 409 {
                    DispatchQueue.main.async {
                        self.showUserExistsAlert()
                    }
                } else if statusCode == 200 {
                    onRoute?(.toActivationScreen(self, viewModel.email))
                }
            }
    }

    @IBAction private func routeToLoginTapped(_ sender: Any) {
        onRoute?(.toLoginScreen(self))
    }
}


// MARK: - Alerts {
private extension SignUpViewController {
    func showUserExistsAlert() {
        let alert = UserExistsPopup()
        alert.onDismiss = { [weak self] in
            self?.clearTextFields()
            alert.animateOut {
                alert.dismiss(animated: true)
            }
        }
        self.present(alert, animated: false) {
            alert.animateIn()
        }
    }

    func clearTextFields() {
        viewModel.username = ""
        usernameTextField.clearTextField()
        viewModel.email = ""
        emailTextField.clearTextField()
        viewModel.password = ""
        passwordTextField.clearTextField()
    }
}


// MARK: - Setup Routing
extension SignUpViewController {
    enum Route {
        case toActivationScreen(BaseViewController, String)
        case toLoginScreen(BaseViewController)
    }
}
