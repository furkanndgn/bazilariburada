//
//  UserService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.11.2024.
//

import Foundation

/// For endpoints in `User` collection
final class UserService: UserServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getUserProfile(with accessToken: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        networkManager
            .performRequest(endpoint: UserEndpoint.getUserProfile, responseType: User.self) { result in
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

    func updateUserProfile(
        newUsername: String,
        newPassword: String,
        with accessToken: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        let updateProfileRequest = UpdateProfileRequest(username: newUsername, password: newPassword)
        networkManager
            .performRequest(
                endpoint: UserEndpoint.updateUser,
                body: updateProfileRequest,
                responseType: String.self,
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
