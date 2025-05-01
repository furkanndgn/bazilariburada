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
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var expandableView: ExpandableView!
    @IBOutlet weak var reviewsRoutingView: ReviewsRoutingView!

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
        handleRouting()
    }

    func configureSubviews() {
        productQuantityView.productStock = viewModel.product.quantity
        productStockLabel.text = "\(viewModel.product.quantity) in stock"
        priceLabel.text = "$\(viewModel.product.price)"
        expandableView.configureView(
            title: "Product Description",
            indicatorImage: UIImage(
                systemName: "chevron.right"
            ),
            content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
        reviewsRoutingView.configureView(with: viewModel.product.averageRating)
    }

    func handleRouting() {
        reviewsRoutingView.tapPerformed = {
            let reviewViewController = ProductReviewsViewController(
                viewModel: ReviewsViewModel(product: self.viewModel.product)
            )
            self.navigationController?.pushViewController(reviewViewController, animated: true)
        }
    }
}
