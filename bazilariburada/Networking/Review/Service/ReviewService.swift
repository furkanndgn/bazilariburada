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

    func getReviews(of productID: String, completion: @escaping (Result<[Review], NetworkError>) -> Void) {
        networkManager
            .performRequest(
                endpoint: ReviewEndpoint.getProductReviews(productID: productID),
                responseType: [Review].self
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        completion(.success(data))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }

    func addReview(
        _ comment: String,
        rating: Int,
        to productID: String,
        with accessToken: String,
        completion: @escaping (Result<Review, NetworkError>) -> Void
    ) {
        let addReviewRequest = AddReviewRequest(rating: rating, comment: comment)
        networkManager
            .performRequest(
                endpoint: ReviewEndpoint.addReview(productID: productID),
                body: addReviewRequest,
                responseType: Review.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        completion(.success(data))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }

    func deleteUserReview(
        from productID: String,
        with accessToken: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        networkManager
            .performRequest(
                endpoint: ReviewEndpoint.deleteReview(productID: productID),
                responseType: EmptyResponse.self,
                token: accessToken
            ) { result in
                switch result {
                case .success(let response):
                    completion(.success(response.message))
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
}
