//
//  ProductQuantityView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.04.2025.
//

import UIKit
import SnapKit

final class ProductQuantityView: UIView {

    private var stack: ProductQuantityStack?
    var productStock = 1

    var quantity: Int {
        stack?.quantity ?? 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setQuantity(_ quantity: Int) {
        stack?.quantity = quantity
    }
}

private extension ProductQuantityView {
    
    func setupView() {
        guard let viewFromNib = ProductQuantityStack.loadFromNib() else { return }
        self.stack = viewFromNib
        addSubview(viewFromNib)
        setupConstraints(of: viewFromNib)
        updateView(with: 1)
        stack?.onQuantityChanged = { [weak self] newQuantity in
            self?.updateView(with: newQuantity)
        }
    }

    func setupConstraints(of subview: UIView) {
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateView(with quantity: Int) {
        updateButtonStates(with: quantity)
        updateTextField(with: quantity)
    }

    func updateButtonStates(with quantity: Int) {
        guard let stack = stack else { return }
        if quantity == 1 {
            stack.minusButton.tintColor = .Colors.black50
            stack.plusButton.tintColor = .Colors.green100
            stack.minusButton.isUserInteractionEnabled = false
            stack.plusButton.isUserInteractionEnabled = true
        } else if quantity == productStock {
            stack.minusButton.tintColor = .Colors.green100
            stack.plusButton.tintColor = .Colors.black50
            stack.minusButton.isUserInteractionEnabled = true
            stack.plusButton.isUserInteractionEnabled = false
        } else {
            stack.minusButton.tintColor = .Colors.green100
            stack.plusButton.tintColor = .Colors.green100
            stack.minusButton.isUserInteractionEnabled = true
            stack.plusButton.isUserInteractionEnabled = true
        }
    }

    func updateTextField(with quantity: Int) {
        stack?.productQuantityText.text = "\(quantity)"
    }
}
