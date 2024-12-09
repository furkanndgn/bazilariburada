//
//  ProductDetailViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 1.12.2024.
//

import UIKit
import Combine

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productStockQuantityLabel: UILabel!
    @IBOutlet weak var productVoteCountLabel: UILabel!
    @IBOutlet weak var starRateView: StarRatingView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var productQuantityStepper: UIStepper!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var product: Product
    var viewModel: ProductDetailViewModel
    
    init(product: Product, viewModel: ProductDetailViewModel = ProductDetailViewModel()) {
        self.product = product
        self.viewModel = viewModel
        super.init(nibName: "ProductDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product.name
        configureView(for: product)
        addSubscribers()
    }
    
    private func configureView(for product: Product) {
        productImageView.image = UIImage(systemName: "bag.fill")
        productPriceLabel.text = product.price?.formatted(.currency(code: "USD"))
        productStockQuantityLabel.text = "\(product.quantity ?? 0) left"
        let reviewCount = product.reviews?.count ?? 0
        productVoteCountLabel.text = reviewCount == 1 ? "\(reviewCount) review" : "\(reviewCount) reviews"
        starRateView.rating = Float(product.averageRating ?? 0)
        productDescriptionLabel.text = product.description
        starRateView.onTap = { [weak self] in
            guard let self = self else { return }
            let reviewsVC = ProductReviewsViewController(product: product)
            self.navigationController?.present(reviewsVC, animated: true)
        }
        productQuantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        productQuantityTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func addSubscribers() {
        viewModel.$itemQuantity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.productQuantityStepper.value = Double(value)
                self?.productQuantityTextField.text = "\(value)"
            }
            .store(in: &viewModel.cancellables)
    }
    
    /// Mark: Activation functions
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        viewModel.itemQuantity = Int(sender.value)
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, let intValue = Int(text) {
            viewModel.itemQuantity = intValue
        }
    }
}
