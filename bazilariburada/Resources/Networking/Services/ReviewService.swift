//
//  ReviewService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

class ReviewService: ObservableObject {
    
    private let networkManager = NetworkManager.shared
    private var reviewSubscription: AnyCancellable?
    @Published var productReviews: [Review]?
    @Published var sentReview: Review?
    @Published var reviewDeletedMessage: String?
    
    func getProductReviews(productID: String) {
        reviewSubscription = networkManager.performRequest(endpoint: "/products/\(productID)/reviews", method: .GET)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.productReviews = response.data
                self?.reviewSubscription?.cancel()
            })
    }
    
    func addProductReview(token: String, productID: String, comment: String, rating: Int) {
        let body = ["comment": comment, "rating": rating] as [String : Any]
        reviewSubscription = networkManager.performRequest(endpoint: "/products/\(productID)/reviews", method: .POST,
                                                           body: body, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.sentReview = response.data
                self?.reviewSubscription?.cancel()
            })
    }
    
    func deleteUserReview(token: String, productID: String) {
        reviewSubscription = networkManager.performRequest(endpoint: "/products/\(productID)/reviews", method: .DELETE,
                                                           requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.reviewDeletedMessage = response.message
                self?.reviewSubscription?.cancel()
            })
    }
}
