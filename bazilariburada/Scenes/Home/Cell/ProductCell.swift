//
//  ProductCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.05.2025.
//

import UIKit

final class ProductCell: BaseCollectionViewCell, NibLoadable {

    var product: Product?

    var onTap: ((String) -> Void)?

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func configure(with product: Product) {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.borderWidth = 1
        activityIndicator.hidesWhenStopped = true
        activityIndicator.layer.cornerRadius = 12
        self.product = product
        nameLabel.text = "\(product.brand) \(product.name)"
        priceLabel.text = product.price.asCurrency(locale: Locale(identifier: "en_US"))
//        productImageView.image = UIImage(systemName: "bag.fill")
        ratingLabel.text = String(format: "%.1f", product.averageRating ?? 0)
    }

    func setLoading(_ loading: Bool) {
        if loading {
            addButton.isHidden = true
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            addButton.isHidden = false
            activityIndicator.stopAnimating()
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        guard let product = product else { return }
        onTap?(product.id)
    }
}
