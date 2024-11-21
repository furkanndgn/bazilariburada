//
//  ReviewService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

class ReviewService {
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var productReviews: [Review]?
    
    func getProductReviews(token: String, productID: String) {
        networkManager.request(endpoint: "products/\(productID)/reviews", method: .GET)
            .decode(type: ApiResponse<[Review]>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.productReviews = response.data
            })
            .store(in: &cancellables)
    }
}
