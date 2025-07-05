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
        setupView()
        self.product = product
        loadProductImage(using: product.imageURL)
        nameLabel.text = "\(product.brand) \(product.name)"
        priceLabel.text = product.price.asCurrency(locale: Locale(identifier: "en_US"))
        ratingLabel.text = String(format: "%.1f", product.averageRating ?? 0)
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

    private func loadProductImage(using urlString: String) {
        if let url = URL(string: urlString) {
            productImageView.load(url: url)
        } else {
            let image = SFSymbol.questionMark.image(with: .gray)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12), scale: .small)
            productImageView.image = image!.withConfiguration(config)
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        guard let product = product else { return }
        onTap?(product.id)
    }

    private func setupView() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.borderWidth = 1
        activityIndicator.layer.cornerRadius = 12
    }
}
