//
//  ProductReviewsViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.12.2024.
//

import UIKit

final class ProductReviewsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    var viewModel: ReviewsViewModel
    
    init(viewModel: ReviewsViewModel) {
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


// MARK: - Setup UI
private extension ProductReviewsViewController {
    func setupView() {
        title = "Reviews"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        let nib = ProductReviewCell.getNib()
        tableView.register(nib, forCellReuseIdentifier: ProductReviewCell.identifier)
        viewModel.getProductReviews()
        let averageRatingString = String(format: "%.1f", viewModel.product.averageRating)
        ratingLabel.text = "Rating: \(averageRatingString)/5"
        starRatingView.configureView(with: viewModel.product.averageRating)
        updateUI()
    }

    func updateUI() {
        if let reviews = viewModel.allReviews, !reviews.isEmpty {
            tableView.reloadData()
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
    }
}


// MARK: - TableView Delegation
extension ProductReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductReviewCell.identifier,
                                                       for: indexPath) as? ProductReviewCell
        else {
            return UITableViewCell()
        }
        let review = viewModel.review(by: indexPath.row)
        cell.configure(for: review)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
