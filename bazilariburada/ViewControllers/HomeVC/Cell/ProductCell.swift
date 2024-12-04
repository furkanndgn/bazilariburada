//
//  ProductCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 29.11.2024.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(product: Product) {
        
        nameLabel.text = "\(product.brand!) \(product.name!)"
        priceLabel.text = product.price?.formatted(.currency(code: "USD"))
        productImageView.image = UIImage(systemName: "bag.fill")
        rateLabel.text = String(format: "%.1f", product.averageRating ?? 0.0)
    }
}
