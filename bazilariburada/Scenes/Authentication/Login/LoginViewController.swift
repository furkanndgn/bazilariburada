//
//  LoginController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import UIKit
import Combine

final class LoginViewController: BaseViewController, RouteEmitting {
    
    @IBOutlet weak var usernameTextField: UnderlinedTextFieldView!
    @IBOutlet weak var passwordTextField: UnderlinedTextFieldView!
    @IBOutlet weak var usernameWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dummyLoginButton: UIButton!

    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    var onRoute: ((Route) -> Void)?

    init(_ viewModel: LoginViewModel) {
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
        hideNavigationBar()
    }

    private func addSubscribers() {
        viewModel.$isLoginEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.loginButton.isHidden = !isEnabled
                self?.dummyLoginButton.isHidden = isEnabled
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


    // MARK: - Activation Functions
    @objc func usernameChanged(_ sender: UITextField) {
        viewModel.username = sender.text ?? ""
    }

    @objc func passwordChanged(_ sender: UITextField) {
        viewModel.password = sender.text ?? ""
    }
    
    @IBAction func dummyLoginTapped(_ sender: Any) {
        if !viewModel.isUsernameValid {
            usernameWarningLabel.isHidden = false
            usernameTextField.makeBorderVisible(true)
        }
        if !viewModel.isPasswordValid {
            passwordWarningLabel.isHidden = false
            passwordTextField.makeBorderVisible(true)
        }
    }

    @IBAction func loginTapped(_ sender: Any) {
        setLoading(true)
        viewModel.login() { [weak self] statusCode in
            guard let self else { return }
            if statusCode == 200 {
                self.onRoute?(.toMainScreen(self))
                setLoading(false)
            }
        }
    }

    @IBAction func registerTapped(_ sender: Any) {
        onRoute?(.toRegisterScreen(self))
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        onRoute?(.toForgotPasswordScreen(self))
    }
}


// MARK: - Setup UI
private extension LoginViewController {
    
    func setupView() {
        setupTextFields()
    }

    func setupTextFields() {
        usernameTextField.textField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        usernameTextField.configureView(according: .username)
        passwordTextField.configureView(according: .password)
    }

    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.loginButton.showLoading(loading)
            if loading {
                self?.usernameTextField.isUserInteractionEnabled = false
                self?.passwordTextField.isUserInteractionEnabled = false
            } else {
                self?.usernameTextField.isUserInteractionEnabled = true
                self?.passwordTextField.isUserInteractionEnabled = true
            }
        }
    }
}


// MARK: - Setup Routing {
extension LoginViewController {
    enum Route {
        case toMainScreen(BaseViewController)
        case toRegisterScreen(BaseViewController)
        case toForgotPasswordScreen(BaseViewController)
    }
}
