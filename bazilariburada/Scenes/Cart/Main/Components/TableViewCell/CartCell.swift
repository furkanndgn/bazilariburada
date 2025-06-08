//
//  CartCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.05.2025.
//

import UIKit

final class CartCell: BaseTableViewCell, NibLoadable {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productQuantityView: ProductQuantityView!

    var quantityChangedWorkItem: DispatchWorkItem?

    var onQuantityChange: ((Int) -> Void)?

    func configureWith(_ cartItem: CartDisplayModel) {
#warning("FIXME: image")
        productImageView.image = UIImage(systemName: "bag")
        nameLabel.text = "\(cartItem.product.brand) \(cartItem.product.name)"
        priceLabel.text = cartItem.cartItem.price.asCurrency(locale: Locale(identifier: "en_US"))
        productQuantityView.productStock = cartItem.product.quantity
        productQuantityView.setQuantity(cartItem.cartItem.quantity)
        configureQuantityView()
    }

    func configureQuantityView() {
        productQuantityView.layer.cornerRadius = 8
        productQuantityView.layer.borderWidth = 1
        productQuantityView.layer.borderColor = UIColor.Colors.black20.cgColor
        productQuantityView.onQuantityChange = { [weak self] quantity in
            self?.quantityChangedWorkItem?.cancel()
            let workItem = DispatchWorkItem {
                self?.onQuantityChange?(quantity)
            }
            self?.quantityChangedWorkItem = workItem
            guard let workItem = self?.quantityChangedWorkItem else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
        }
    }
}
