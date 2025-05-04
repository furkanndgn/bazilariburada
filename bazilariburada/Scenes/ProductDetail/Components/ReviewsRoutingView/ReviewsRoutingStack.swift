//
//  ReviewsRoutingStack.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 30.04.2025.
//

import UIKit

final class ReviewsRoutingStack: UIView, NibLoadable {

    @IBOutlet weak var starRatingView: StarRatingView!


    func configureStarRating(with rating: Double) {
        starRatingView.configureView(with: rating)
    }
}
