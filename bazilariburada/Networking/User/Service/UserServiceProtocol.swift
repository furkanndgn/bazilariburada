//
//  UserServiceProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol UserServiceProtocol {

    func getUserProfile(with accessToken: String, completion: @escaping (Result<User, NetworkError>) -> Void)

    func updateUserProfile(
        newUsername: String,
        newPassword: String,
        with accessToken: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
}
