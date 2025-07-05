//
//  ProfileViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.06.2025.
//

import UIKit

final class ProfileViewController: BaseViewController {

    private let viewModel: ProfileViewModel

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var orderSection: UIView!
    @IBOutlet weak var addressSection: UIView!
    @IBOutlet weak var paymentSection: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel.getProfile()
            setupView()
        }
    }

    init(_ viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func logoutTapped(_ sender: Any) {
        viewModel.logout()
    }

    @objc func orderTapped() {
        let viewController = UserOrdersViewController(UserOrdersViewModel())
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func addressTapped() {
        let viewController = AddressListingViewController(AddressViewModel())
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func paymentTapped() {
        let viewController = PaymentMethodsListingViewController(PaymentMethodsViewModel())
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - Setup UI
private extension ProfileViewController {

    func setupView() {
        guard let user = viewModel.userDetail else { return }
        usernameLabel.text = user.username
        emailLabel.text = user.email
        setGestures()
    }

    func setGestures() {
        let orderGesture = UITapGestureRecognizer(target: self, action: #selector(orderTapped))
        orderSection.addGestureRecognizer(orderGesture)
        let addressGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        addressSection.addGestureRecognizer(addressGesture)
        let paymentGesture = UITapGestureRecognizer(target: self, action: #selector(paymentTapped))
        paymentSection.addGestureRecognizer(paymentGesture)
    }
}
