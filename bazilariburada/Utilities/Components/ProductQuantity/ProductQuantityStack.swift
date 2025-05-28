//
//  ProductQuantityStack.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.04.2025.
//

import UIKit

final class ProductQuantityStack: UIStackView, NibLoadable {

    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var productQuantityText: UITextField!

    var quantity: Int = 1 {
        didSet {
            onQuantityChanged?(quantity)
        }
    }

    var onQuantityChanged: ((Int) -> Void)?

    @IBAction func minusButtonTapped(_ sender: UIButton) {
        quantity -= 1
    }

    @IBAction func plusButtonTapped(_ sender: Any) {
        quantity += 1
    }
}
