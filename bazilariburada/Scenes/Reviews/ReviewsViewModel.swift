//
//  ReviewsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.12.2024.
//

import Foundation

final class ReviewsViewModel {

    private let reviewService: ReviewService
    let product: Product
    var allReviews: [Review]?
    var reviewCount: Int?
    
    init(product: Product, reviewService: ReviewService = ReviewService()) {
        self.product = product
        allReviews = product.reviews
        reviewCount = allReviews?.count
        self.reviewService = reviewService
        addSubscribers()
    }

    func review(by index: Int) -> Review {
        return allReviews![index]
    }
    
    func getProductReviews() {
    }
    
    func addReview(comment: String, rating: Int, userData: LoginResponse) {
    }
    
    func deleteUserReview(_ userData: LoginResponse) {
    }
    
    private func addSubscribers() {
    }
}
