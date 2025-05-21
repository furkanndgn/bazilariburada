//
//  OTPTextFieldView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 19.05.2025.
//

import UIKit

class OTPTextFieldView: UIView, NibLoadable {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stack: UIStackView!

    private let codeLength = 6

    private var textFields: [UITextField] {
        stack.arrangedSubviews.compactMap { $0 as? UITextField }.sorted { $0.tag < $1.tag }
    }

    private var activationCode: String {
        textFields.compactMap { $0.text }.joined()
    }

    var codeCompleted: MessageHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed(Self.nibName, owner: self)
        addSubview(contentView)
        setupView()
    }

    func setupDelegates(with delegate: UITextFieldDelegate) {
        textFields.forEach { textField in
            textField.delegate = delegate
        }
    }
}


// MARK: - Activation and Helper Functions
private extension OTPTextFieldView {

    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }

        if text.count > 1 {
            handlePaste(text)
            return
        }

        if text.count == 1 {
            let nextTag = sender.tag + 1
            if nextTag < codeLength {
                textFields[nextTag].becomeFirstResponder()
            } else {
                sender.resignFirstResponder()
                codeCompleted?(activationCode)
            }
        } else if text.count == 0 {
            let prevTag = sender.tag - 1
            if prevTag >= 0 {
                textFields[prevTag].becomeFirstResponder()
            }
        }
    }

    func handlePaste(_ string: String) {
        let numbers = Array(string.prefix(codeLength))
        for (index, char) in numbers.enumerated() {
            textFields[index].text = String(char)
        }
        if numbers.count == codeLength {
            superview?.endEditing(true)
            codeCompleted?(activationCode)
        } else if numbers.count > 0 {
            textFields[numbers.count].becomeFirstResponder()
        }
    }
}


// MARK: - Setup UI
private extension OTPTextFieldView {
    
    func setupView() {
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        setupTextFields()
    }

    func setupTextFields() {
        textFields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textField.layer.cornerRadius = 8
            textField.layer.masksToBounds = true
        }
        textFields.first?.becomeFirstResponder()
    }
}
