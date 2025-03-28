//
//  File.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol AuthenticationServiceProtocol {

    func registerUser(
        username: String,
        email: String,
        password: String,
        completion: @escaping (Result<RegisterResponse, NetworkError>) -> Void
    )

    func activateAccount(
        email: String,
        activationCode: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )

    func loginUsing(
        username: String,
        password: String,
        completion: @escaping (Result<LoginResponse, NetworkError>) -> Void
    )

    func refreshAccessToken(
        with refreshToken: String,
        completion: @escaping (Result<RefreshAccessTokenResponse, NetworkError>) -> Void
    )

    func sendResetPasswordCode(
        to email: String,
        completion: @escaping (Result<ForgetPasswordResponse, NetworkError>) -> Void
    )

    func resetPassword(
        resetPasswordCode: String,
        newPassword: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
}
