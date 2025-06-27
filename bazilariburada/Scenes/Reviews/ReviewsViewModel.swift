//
//  ReviewsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.12.2024.
//

import Foundation
import Combine

final class ReviewsViewModel {

    private let reviewService: ReviewService
    private let authenticationManager: AuthenticationManager

    let product: Product
    @Published private(set) var allReviews = [Review]()
    var reviewCount: Int {
        allReviews.count
    }

    init(
        product: Product,
        reviewService: ReviewService = ReviewService(),
        authenticationManager: AuthenticationManager = AuthenticationManager.shared
    ) {
        self.product = product
        allReviews = product.reviews
        self.reviewService = reviewService
        self.authenticationManager = authenticationManager
    }

    func review(by index: Int) -> Review {
        return allReviews[index]
    }
    
    func getProductReviews() async {
        let response = await reviewService.getReviews(of: product.id)
        guard let reviews = response?.data else { return }
        allReviews = reviews
        print(allReviews)
    }
    
    func addReview(
        comment: String,
        rating: Int,
        completion: @escaping (
            APIResponse<Review>?
        ) -> Void
    ) async {
        let response = await reviewService.addReview(
            comment,
            rating: rating,
            to: product.id,
            with: authenticationManager.accessToken ?? ""
        )
        await getProductReviews()
        completion(response)
    }
    
    func deleteUserReview() async {
        let response = await reviewService.deleteUserReview(
            from: product.id,
            with: authenticationManager.accessToken ?? ""
        )
        await getProductReviews()
    }
}
