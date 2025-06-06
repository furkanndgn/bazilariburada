//
//  ActivationViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import UIKit

final class ActivationViewController: BaseViewController {

    private let viewModel: ActivationViewModel

    @IBOutlet weak var textFieldView: OTPTextFieldView!
    @IBOutlet weak var emailMessage: UILabel!
    @IBOutlet weak var resendButton: UIButton!

    var onFinish: ((ActivationResult) -> Void)?

    init(_ viewModel: ActivationViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated: animated)
    }

    @IBAction func resendButtonTapped(_ sender: Any) {
        onFinish?(.failure)
    }
}


// MARK: - Setup UI
private extension ActivationViewController {
    func setupView() {
        textFieldView.setupDelegates(with: self)
        textFieldView.codeCompleted = { [weak self] activationCode in
            guard let self, let activationCode else { return }
            self.viewModel.activateAccount(activationCode, completion: { statusCode in
                if statusCode == 200 {
                    self.onFinish?(.success)
                } else {
#warning ("TODO: Implement this")
                }
            })
        }
        emailMessage.text = Constants.Formatter.activationMessage(viewModel.email)
    }
}


// MARK: - UITextFieldDelegate
extension ActivationViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if string.isEmpty { return true }
        if let current = textField.text, let r = Range(range, in: current) {
            let updated = current.replacingCharacters(in: r, with: string)
            return updated.count <= 1 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return false
    }
}


enum ActivationResult {
    case success
    case failure
}
