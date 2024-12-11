//
//  ProductReviewsViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.12.2024.
//

import UIKit

class ProductReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var viewModel: ReviewsViewModel
    var product: Product
    
    init(product: Product, viewModel: ReviewsViewModel = ReviewsViewModel()) {
        self.product = product
        self.viewModel = viewModel
        super.init(nibName: "ProductReviewsViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubscription()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ProductReviewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewCell")
        viewModel.getProductReviews(for: product)
        let avgRatingString = String(format: "%.1f", product.averageRating ?? 0)
        ratingLabel.text = "\(avgRatingString) out of 5"
        starRatingView.rating = Float(product.averageRating ?? 0)
    }
    
    private func addSubscription() {
        viewModel.$allReviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func updateUI() {
        if let reviews = viewModel.allReviews, !reviews.isEmpty {
            tableView.reloadData()
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
    }
}


extension ProductReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell",
                                                       for: indexPath) as? ProductReviewCell
        else {
            return UITableViewCell()
        }
        let review = viewModel.review(by: indexPath.row)
        cell.configure(for: review)
        return cell
    }
}
