//
//  ForgotPasswordViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import UIKit
import Combine

final class ForgotPasswordViewController: BaseViewController, RouteEmitting {

    @IBOutlet weak var emailTextField: UnderlinedTextFieldView!
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dummySendButton: UIButton!

    private let viewModel: ForgotPasswordViewModel
    private var cancellables = Set<AnyCancellable>()

    var onRoute: ((Route) -> Void)?

    init(_ viewModel: ForgotPasswordViewModel) {
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

    @IBAction func sendTapped(_ sender: Any) {
        setLoading(true)
        viewModel.sendCode { [weak self] statusCode in
            guard let self else { return }
            if statusCode == 200 {
                onRoute?(.toResetPassword(self, viewModel.email))
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }

    @IBAction func dummySendTapped(_ sender: Any) {
        emailWarningLabel.isHidden = false
        emailTextField.makeBorderVisible(true)
    }

    @objc func emailChanged(_ sender: UITextField) {
        viewModel.email = sender.text ?? ""
    }

    private func addSubscribers() {
        viewModel.$isEmailValid
            .sink { [weak self] isValid in
                self?.sendButton.isHidden = !isValid
                self?.dummySendButton.isHidden = isValid
                if isValid {
                    self?.emailTextField.makeBorderInvisible()
                    self?.emailWarningLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
}


// MARK: - Setup UI
private extension ForgotPasswordViewController {

    func setupView() {
        emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        emailTextField.configureView(according: .email)
    }

    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.sendButton.showLoading(loading)
            if loading {
                self?.emailTextField.isUserInteractionEnabled = false
            } else {
                self?.emailTextField.isUserInteractionEnabled = true
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
extension ForgotPasswordViewController {
    enum Route {
        case toResetPassword(BaseViewController, String)
        case toLogin(BaseViewController)
    }
}
