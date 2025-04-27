//
//  ProductDetailViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 1.12.2024.
//

import UIKit

final class ProductDetailViewController: BaseViewController {

    var viewModel: ProductDetailViewModel
    
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productQuantityView: ProductQuantityView!
    @IBOutlet weak var productDescriptionSection: ProductDescriptionSection!

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension ProductDetailViewController {

    func setupView() {
        self.title = viewModel.product.name
        configureSubviews()
    }

    func configureSubviews() {
        productQuantityView.productStock = viewModel.product.quantity
        productStockLabel.text = "\(viewModel.product.quantity) in stock"
        productDescriptionSection.configureView(with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit")
    }
}
