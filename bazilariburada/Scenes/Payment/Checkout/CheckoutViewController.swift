//
//  CheckoutViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import UIKit

final class CheckoutViewController: BaseViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setGestures()
    }

    func configureView(totalPrice: Double, address: Address, payment: PaymentMethod) {
        addressNameLabel.text = address.name
        paymentProviderLogo.image = payment.brand.brandIcon()
        cardLastFourDigits.text = "**** \(payment.number)"
    }
}


private extension CheckoutViewController {

    func setGestures() {
        let addressGesture = UITapGestureRecognizer(target: self, action: #selector(addressSectionTapped))
        addressSection.addGestureRecognizer(addressGesture)
        let paymentGesture = UITapGestureRecognizer(target: self, action: #selector(paymentSectionTapped))
        paymentSection.addGestureRecognizer(paymentGesture)
        let promoCodeGesture = UITapGestureRecognizer(target: self, action: #selector(promoCodeSectionTapped))
        promoCodeSection.addGestureRecognizer(promoCodeGesture)
    }

    @objc func addressSectionTapped() {
        print("address tapped")
    }

    @objc func paymentSectionTapped() {
        let newVC = PaymentMethodsListingViewController(PaymentMethodsViewModel())
        newVC.title = "Payment Methods"
        let nav = UINavigationController(rootViewController: newVC)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }

    @objc func promoCodeSectionTapped() {
        print("promo code tapped")
    }
}
