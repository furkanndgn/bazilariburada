//
//  ReviewsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.12.2024.
//

import Foundation
import Combine

class ReviewsViewModel {
    private let reviewService: ReviewService
    var cancellables = Set<AnyCancellable>()
    
    @Published var allReviews: [Review]?
    @Published var reviewCount: Int?
    
    init(reviewSerview: ReviewService = ReviewService()) {
        self.reviewService = reviewSerview
        addSubscribers()
    }

    func review(by index: Int) -> Review {
        return allReviews![index]
    }
    
    func getProductReviews(for product: Product) {
        reviewService.getProductReviews(productID: product.id ?? "")
    }
    
    func addReview(for product: Product, comment: String, rating: Int, userData: LoginResponseData) {
        reviewService.addProductReview(token: userData.accessToken, productID: product.id ?? "", comment: comment, rating: rating)
    }
    
    func deleteReview(for product: Product, userData: LoginResponseData) {
        reviewService.deleteUserReview(token: userData.accessToken, productID: product.id ?? "")
    }
    
    private func addSubscribers() {
        reviewService.$productReviews
            .sink { [weak self] returnedReivews in
                self?.allReviews = returnedReivews
                self?.reviewCount = returnedReivews?.count
            }
            .store(in: &cancellables)
    }
}
