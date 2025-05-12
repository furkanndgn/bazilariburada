//
//  ReviewServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol ReviewServiceProtocol {
    
    func getReviews(of productID: String) async -> APIResponse<[Review]>?
    func addReview(
        _ comment: String,
        rating: Int,
        to productID: String,
        with accessToken: String
    ) async -> APIResponse<Review>?
    func deleteUserReview(from productID: String, with accessToken: String) async -> String?
}
