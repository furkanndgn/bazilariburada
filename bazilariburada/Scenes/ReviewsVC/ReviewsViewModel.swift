//
//  ReviewsViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.12.2024.
//

import Foundation
import Combine

class ReviewsViewModel: ObservableObject {
    
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
    }
    
    func addReview(for product: Product, comment: String, rating: Int, userData: LoginResponse) {
    }
    
    func deleteReview(for product: Product, userData: LoginResponse) {
    }
    
    private func addSubscribers() {
    }
}
