//
//  ProductReviewsTableViewCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.12.2024.
//

import UIKit

final class ProductReviewCell: BaseTableViewCell, NibLoadable {

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!

    func configure(for review: Review) {
        reviewLabel.text = review.comment
        usernameLabel.text = review.username
        reviewDateLabel.text = review.date
        starRatingView.configureView(with: Double(review.rating))
    }
}
