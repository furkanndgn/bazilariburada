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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(product: Product) {
        nameLabel.text = product.name
        let formattedPrice = product.price?.formatted(.currency(code: "USD"))
        priceLabel.text = formattedPrice
        productImageView.image = UIImage(systemName: "bag.fill")
    }
}
