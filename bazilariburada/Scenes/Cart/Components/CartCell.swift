//
//  CartCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.05.2025.
//

import UIKit

final class CartCell: BaseTableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productQuantityView: ProductQuantityView!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellWith(_ product: Product, quantity: Int) {
        // TODO: Implement image
        productImageView.image = UIImage(systemName: "bag")
        nameLabel.text = "\(product.brand) \(product.name)"
        priceLabel.text = product.price.asCurrency(locale: Locale(identifier: "en_US"))
        productQuantityView.productStock = product.quantity
        productQuantityView.setQuantity(quantity)
    }
}
