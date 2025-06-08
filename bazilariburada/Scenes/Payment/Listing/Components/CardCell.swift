//
//  CardCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import UIKit

final class CardCell: BaseTableViewCell, NibLoadable {

    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var selectedCardIndicator: UIImageView!

    func configure(with paymentMethod: PaymentMethod) {
        cardNumberLabel.text = paymentMethod.number.maskedCardNumber
        brandImageView.image = paymentMethod.brand.brandIcon()
        selectedCardIndicator.isHidden = !paymentMethod.isSelected
    }
}
