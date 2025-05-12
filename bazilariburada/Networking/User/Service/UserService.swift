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

    func getUserProfile(with accessToken: String) async -> APIResponse<User>? {
        do {
            return try await networkManager
                .performRequest(endpoint: UserEndpoint.getUserProfile, token: accessToken)
        } catch let error {
            print(error)
        }
        return nil
    }

    func updateUserProfile(
        newUsername: String,
        newPassword: String,
        with accessToken: String) async -> String? {
            let updateProfileRequest = UpdateProfileRequest(username: newUsername, password: newPassword)
            var message: String?
            do {
                let response: APIResponse<UpdateUserProfileResponse> = try await networkManager.performRequest(
                    endpoint: UserEndpoint.updateUser,
                    token: accessToken,
                    body: updateProfileRequest
                )
                message = response.message
            } catch let error {
                print(error)
            }
            return message
        }
}
