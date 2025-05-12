//
//  UserServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol UserServiceProtocol {

    func getUserProfile(with accessToken: String) async -> APIResponse<User>?
    func updateUserProfile(
        newUsername: String,
        newPassword: String,
        with accessToken: String) async -> String?
}
