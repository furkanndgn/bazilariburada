//
//  CheckoutViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import UIKit

final class CheckoutViewController: BaseViewController {

    private let viewModel: CheckoutViewModel

    @IBOutlet weak var addressSection: UIView!
    @IBOutlet weak var paymentSection: UIView!
    @IBOutlet weak var promoCodeSection: UIView!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var paymentProviderLogo: UIImageView!
    @IBOutlet weak var cardLastFourDigits: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var dummyCheckoutButton: UIButton!

    init(_ viewModel: CheckoutViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setGestures()
    }

    @objc func addressSectionTapped() {
        print("address tapped")
    }

    @objc func paymentSectionTapped() {
        let newVC = PaymentMethodsListingViewController(PaymentMethodsViewModel())
        newVC.selectedMethodChanged = { [weak self] in
            self?.updateSelectedPaymentMethod()
        }
        newVC.title = "Payment Methods"
        let nav = UINavigationController(rootViewController: newVC)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }

    @objc func promoCodeSectionTapped() {
        print("promo code tapped")
    }
}


// MARK: - Setup UI
private extension CheckoutViewController {

    func setupView() {
        total.text = viewModel.totalPrice.formatted(.currency(code: "USD"))
//        addressNameLabel. text = viewModel.selectedAddress?.name
        paymentProviderLogo.image = viewModel.selectedPaymentMethod?.brand.brandIcon()
        cardLastFourDigits.text = viewModel.selectedPaymentMethod?.number.maskedCardNumber
    }

    func setGestures() {
        let addressGesture = UITapGestureRecognizer(target: self, action: #selector(addressSectionTapped))
        addressSection.addGestureRecognizer(addressGesture)
        let paymentGesture = UITapGestureRecognizer(target: self, action: #selector(paymentSectionTapped))
        paymentSection.addGestureRecognizer(paymentGesture)
        let promoCodeGesture = UITapGestureRecognizer(target: self, action: #selector(promoCodeSectionTapped))
        promoCodeSection.addGestureRecognizer(promoCodeGesture)
    }

    func updateSelectedPaymentMethod() {
        paymentProviderLogo.image = viewModel.selectedPaymentMethod?.brand.brandIcon()
        cardLastFourDigits.text = viewModel.selectedPaymentMethod?.number.maskedCardNumber
    }
}
