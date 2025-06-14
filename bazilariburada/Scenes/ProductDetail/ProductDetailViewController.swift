//
//  ProductDetailViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 1.12.2024.
//

import UIKit
import Combine

final class ProductDetailViewController: BaseViewController, RouteEmitting {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productQuantityView: ProductQuantityView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var expandableView: ExpandableView!
    @IBOutlet weak var reviewsRoutingView: ReviewsRoutingView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!


    var onRoute: ((Route) -> Void)?
    private let viewModel: ProductDetailViewModel
    private var cancellables = Set<AnyCancellable>()

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
        addSubscribers()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        setLoading(true)
        Task {
            await viewModel.addToCart(quantity: productQuantityView.quantity)
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        Task {
            if viewModel.isInWishlist {
                await viewModel.removeFromWishlist()
            } else {
                await viewModel.addToWishlist()
            }
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

    func addSubscribers() {
        viewModel.$isInWishlist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isInWishlist in
                self?.setFavorited(isInWishlist)
            }
            .store(in: &cancellables)
    }

#warning ("TODO: productNameLabel -> brandNameLabel + productNameLabel")
#warning("FIXME: image")
    func configureSubviews() {
        productNameLabel.text = "\(viewModel.product.brand) \(viewModel.product.name)"
        productQuantityView.productStock = viewModel.product.quantity
        productStockLabel.text = Constants.Formatter.stock(viewModel.product.quantity)
        priceLabel.text = viewModel.product.price.asCurrency(locale: Locale(identifier: "en_US"))
        expandableView.configureView(
            title: Constants.Text.Title.productDescription,
            indicatorImage: SFSymbol.chevronRight.image(with: .Colors.black100),
            content: viewModel.product.description
        )
        reviewsRoutingView.configureView(with: viewModel.product.averageRating ?? 0)
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

    func setFavorited(_ favorited: Bool) {
        if favorited {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.favoriteButton.setImage(SFSymbol.heartFill.image(with: .systemRed), for: .normal)
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.favoriteButton.setImage(SFSymbol.heart.image(with: .systemGray), for: .normal)
            }
        }
    }
}


// MARK: - Handle Routing
extension ProductDetailViewController {
    enum Route {
        case toReviewScene(UIViewController)
    }
}
