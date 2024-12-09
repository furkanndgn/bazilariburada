//
//  ProductReviewsTableViewCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.12.2024.
//

import UIKit

class ProductReviewCell: UITableViewCell {

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(for review: Review) {
        reviewLabel.text = review.comment
        usernameLabel.text = review.username
        reviewDateLabel.text = review.date
        starRatingView.rating = Float(review.rating ?? 0)
    }
}
