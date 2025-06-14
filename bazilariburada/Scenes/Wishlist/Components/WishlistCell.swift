//
//  WishlistCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.06.2025.
//

import UIKit

class WishlistCell: BaseTableViewCell, NibLoadable {

    var item: WishlistItem?

    var onTap: ((String) -> Void)?

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func configure(with wishlistItem: WishlistItem) {
        setupView()
        self.item = wishlistItem
        productImageView.image = UIImage(systemName: "bag")
        productNameLabel.text = wishlistItem.name
        priceLabel.text = wishlistItem.price.asCurrency(locale: Locale(identifier: "en_US"))
    }

    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if loading {
                self?.addButton.isHidden = true
                self?.activityIndicator.startAnimating()
                self?.activityIndicator.isHidden = false
            } else {
                self?.addButton.isHidden = false
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        guard let item = item else { return }
        onTap?(item.id)
    }

    private func setupView() {
        activityIndicator.layer.cornerRadius = 8
    }
}
