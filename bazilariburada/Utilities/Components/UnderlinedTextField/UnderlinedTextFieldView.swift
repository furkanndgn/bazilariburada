//
//  UnderlinedTextView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.05.2025.
//

import UIKit

class UnderlinedTextFieldView: UIView, NibLoadable {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configureView(according useCase: UseCase) {
        switch useCase {
        case .email:
            configureToEmailSpec()
        case .password:
            configureToPasswordSpec()
        case .username:
            configureToUsernameSpec()
        case .securityCode:
            configureToSecurityCodeSpec()
        }
    }

    func makeBorderVisible(_ animated: Bool = false) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.textField.layer.borderWidth = 1
        }
        if animated {
            shake(textField)
        }
    }

    func makeBorderInvisible() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.textField.layer.borderWidth = 0
        }
    }

    func clearTextField() {
        textField.text = nil
    }

    private func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed(Self.nibName, owner: self, options: nil)
        addSubview(contentView)
        setupView()
    }
}


// MARK: - Setup UI
private extension UnderlinedTextFieldView {
    func setupView() {
        backgroundColor = .clear
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemRed.cgColor
        contentView.backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func configureToEmailSpec() {
        descriptionLabel.text = Constants.Text.Title.email
        textField.placeholder = Constants.Text.Placeholder.email
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
    }

    func configureToUsernameSpec() {
        descriptionLabel.text = Constants.Text.Title.username
        textField.placeholder = Constants.Text.Placeholder.username
        textField.textContentType = .username
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
    }

    func configureToPasswordSpec() {
        descriptionLabel.text = Constants.Text.Title.password
        textField.placeholder = Constants.Text.Placeholder.password
        textField.textContentType = .password
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
    }

    func configureToSecurityCodeSpec() {
        descriptionLabel.text = Constants.Text.Title.securityCode
        textField.placeholder = Constants.Text.Placeholder.securityCode
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
    }

    func shake(_ views: UIView...) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.values = [-8, 8, -6, 6, -4, 4, -2, 2, 0]
        animation.duration = 0.4
        views.forEach { view in
            view.layer.add(animation, forKey: "shake")
        }
    }
}


// MARK: - Helper Enum
enum UseCase {
    case email, password, username, securityCode
}
