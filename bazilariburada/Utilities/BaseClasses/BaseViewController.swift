//
//  BaseViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Initializers

    init() {
        super.init(nibName: Self.nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Nib Handling

    class var nibName: String {
        return String(describing: self)
    }

    // MARK: - Common Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        commonInit()
    }

    func commonInit() {
        // Override in subclasses for common setup
    }

    func hideNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .Colors.black100
    }
}
