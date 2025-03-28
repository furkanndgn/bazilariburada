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
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productQuantityStepper: UIStepper!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var viewModel: ProductDetailViewModel
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ProductDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.product.name
        setupView(with: viewModel.product)
        addSubscribers()
    }
    
    private func setupView(with product: Product) {
        productImageView.image = UIImage(systemName: "bag.fill")
        productPriceLabel.text = product.price.formatted(.currency(code: "USD"))
        productStockQuantityLabel.text = "\(product.quantity) left"
        let reviewCount = product.reviews.count
        productVoteCountLabel.text = reviewCount == 1 ? "\(reviewCount) review" : "\(reviewCount) reviews"
        starRateView.rating = Float(product.averageRating)
        productDescriptionLabel.text = product.description
        starRateView.onTap = { [weak self] in
            guard let self = self else { return }
            let reviewsVC = ProductReviewsViewController(product: product)
            self.navigationController?.present(reviewsVC, animated: true)
        }
        productQuantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        productQuantityStepper.maximumValue = Double(viewModel.product.quantity)
        productQuantityLabel.layer.cornerRadius = productQuantityLabel.frame.height / 2
        productQuantityLabel.clipsToBounds = true
    }
    
    private func addSubscribers() {
        viewModel.$itemQuantity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.productQuantityStepper.value = Double(value)
                self?.productQuantityLabel.text = "\(value)"
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: Activation functions
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        viewModel.updateItemQuantity(quantity: Int(sender.value))
    }
}
