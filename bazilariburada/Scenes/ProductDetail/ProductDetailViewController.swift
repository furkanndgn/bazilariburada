//
//  ProductDetailViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 1.12.2024.
//

import UIKit

final class ProductDetailViewController: BaseViewController, RouteEmitting {

    var onRoute: ((Route) -> Void)?

    let viewModel: ProductDetailViewModel

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productQuantityView: ProductQuantityView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var expandableView: ExpandableView!
    @IBOutlet weak var reviewsRoutingView: ReviewsRoutingView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    init(_ viewModel: ProductDetailViewModel) {
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

    @IBAction func addButtonTapped(_ sender: Any) {
        setLoading(true)
        Task {
            await viewModel.addToCart(quantity: productQuantityView.quantity)
        }
    }
}


// MARK: - Setup UI
private extension ProductDetailViewController {

    func setupView() {
        self.title = viewModel.product.name
        configureSubviews()
        handleRouting()
    }


//    TODO: productNameLabel -> brandNameLabel + productNameLabel
    func configureSubviews() {
        productNameLabel.text = "\(viewModel.product.brand) \(viewModel.product.name)"
        productQuantityView.productStock = viewModel.product.quantity
        productStockLabel.text = Constants.Formatter.stock(viewModel.product.quantity)
        priceLabel.text = "$\(viewModel.product.price)"
        expandableView.configureView(
            title: Constants.Text.Title.productDescription,
            indicatorImage: SFSymbol.chevronRight.image(with: .Colors.black100),
            content: viewModel.product.description
        )
        reviewsRoutingView.configureView(with: viewModel.product.averageRating)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.layer.cornerRadius = 12
        viewModel.onCartUpdate = { [weak self] in
            self?.setLoading(false)
        }
    }

    func handleRouting() {
        reviewsRoutingView.tapPerformed = {
            self.onRoute?(.toReviewScene(self))
        }
    }

    func setLoading(_ loading: Bool) {
        if loading {
            addButton.isHidden = true
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            addButton.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
}

extension ProductDetailViewController {
    enum Route {
        case toReviewScene(UIViewController)
    }
}
