//
//  WishlistCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.06.2025.
//

import UIKit

class WishlistCell: BaseTableViewCell, NibLoadable {

    var item: WishlistItem?

    var onTap: MessageHandler?

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func configure(with wishlistItem: WishlistItem) {
        self.item = wishlistItem
        productImageView.image = UIImage(systemName: "bag")
        productNameLabel.text = wishlistItem.name
        priceLabel.text = wishlistItem.price.asCurrency(locale: Locale(identifier: "en_US"))
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
        guard let item = item else { return }
        onTap?(item.id)
    }

    private func setupView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.layer.cornerRadius = 8
    }
}
