//
//  ReviewServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol ReviewServiceProtocol {

    func getReviews(of productID: String, completion: @escaping (Result<[Review], NetworkError>) -> Void)

    func addReview(
        _ comment: String,
        rating: Int,
        to productID: String,
        with accessToken: String,
        completion: @escaping (Result<Review, NetworkError>) -> Void
    )

    func deleteUserReview(
        from productID: String,
        with accessToken: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
}
