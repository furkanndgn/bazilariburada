//
//  ReviewService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation

/// For endpoints in `Review` collection
final class ReviewService: ReviewServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getReviews(of productID: String) async -> APIResponse<[Review]>? {
        do {
            return try await networkManager
                .performRequest(
                    endpoint: ReviewEndpoint.getProductReviews(productID: productID)
                )
        } catch let error {
            print(error)
        }
        return nil
    }

    func addReview(
        _ comment: String,
        rating: Int,
        to productID: String,
        with accessToken: String
    ) async -> APIResponse<Review>? {
        let addReviewRequest = AddReviewRequest(rating: rating, comment: comment)
        do {
            return try await networkManager
                .performRequest(
                    endpoint: ReviewEndpoint.addReview(productID: productID),
                    token: accessToken,
                    body: addReviewRequest
                )
        } catch let error {
            print(error)
        }
        return nil
    }

    func deleteUserReview(from productID: String, with accessToken: String) async -> String? {
        var message: String?
        do {
            let response: APIResponse<EmptyResponse> = try await networkManager.performRequest(
                endpoint: ReviewEndpoint.deleteReview(productID: productID),
                token: accessToken
            )
            message = response.message
        } catch let error {
            print(error)
        }
        return message
    }
}
