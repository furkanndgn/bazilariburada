//
//  UserService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation
import Combine

class UserService {
    private let usersKeyword = "/users/profile"
    
    private let networkManager = NetworkManager.shared
    private var userSubscription: AnyCancellable?
    
    @Published var user: User?
    @Published var profileUpdatedData: String?
    
    func getUserProfile(token: String) {
        
        userSubscription = networkManager.performRequest(endpoint: usersKeyword, method: .GET, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.user = response.data
                self?.userSubscription?.cancel()
            })
    }
    
    func updateUserProfile(token: String, username: String, password: String) {
        let body = ["username": username, "password": password]
        
        userSubscription = networkManager.performRequest(endpoint: usersKeyword, method: .PATCH, body: body, requiresAuthentication: true, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.profileUpdatedData = response.data
            })
    }
}
