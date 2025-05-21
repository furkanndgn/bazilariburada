//
//  ErrorPopupViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.05.2025.
//

import UIKit

class ErrorPopupViewController: UIViewController, NibLoadable {

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var container: UIView!

    private var errorTitle = Constants.Text.Error.defaultTitle
    private var errorMessage = ""

    var onDismiss: Completion?

    init() {
        super.init(nibName: ErrorPopupViewController.nibName, bundle: Bundle(for: ErrorPopupViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        titleLabel.text = errorTitle
        messageLabel.text = errorMessage
    }

    func configurePopup(title: String, message: String) {
        errorTitle = title
        errorMessage = message
    }

    func animateIn() {
        container.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
        blurView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseIn
        ) {
            self.container.transform = .identity
            self.blurView.alpha = 1
        }
    }

    func animateOut(completion: @escaping Completion) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseIn,
            animations: {
                self.container.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                self.blurView.alpha = 0
            },
            completion: { _ in
                completion()
            }
        )
    }

    // MARK: - ActivationFunction
    @IBAction func dismissButtonTapped(_ sender: Any) {
        onDismiss?()
    }
}

// MARK: - Setup UI
private extension ErrorPopupViewController {
    func setupView() {
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.clear.cgColor
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
    }
}
