//
//  AuthenticationService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation

/// For endpoints in `Authentication` collection
final class AuthenticationService: AuthenticationServiceProtocol, AccessTokenRefreshProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func registerUser(
        username: String,
        email: String,
        password: String,
        completion: @escaping (Result<RegisterResponse, NetworkError>) -> Void
    ) {
        let registerRequest = RegisterRequest(username: username, email: email, password: password)
        networkManager
            .performRequest(
                endpoint: AuthenticationEndpoint.register,
                body: registerRequest,
                responseType: RegisterResponse.self
            ) { result in
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

    func activateAccount(
        email: String,
        activationCode: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        let activateUser = ActivateAccountRequest(email: email, activationCode: activationCode)
        networkManager
            .performRequest(
                endpoint: AuthenticationEndpoint.activateAccount,
                body: activateUser,
                responseType: EmptyResponse.self
            ) { result in
                switch result {
                case .success(let response):
                    completion(.success(response.message))
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }

    func loginUsing(
        username: String,
        password: String,
        completion: @escaping (Result<LoginResponse, NetworkError>) -> Void
    ) {
        let loginRequest = LoginRequest(username: username, password: password)
        networkManager
            .performRequest(
                endpoint: AuthenticationEndpoint.login,
                body: loginRequest,
                responseType: LoginResponse.self
            ) { result in
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

    func refreshAccessToken(
        with refreshToken: String,
        completion: @escaping (Result<RefreshAccessTokenResponse, NetworkError>) -> Void
    ) {
        let refreshTokenRequest = RefreshTokenRequest(refreshToken: refreshToken)
        networkManager
            .performRequest(
                endpoint: AuthenticationEndpoint.refreshAccessToken,
                body: refreshTokenRequest,
                responseType: RefreshAccessTokenResponse.self
            ) { result in
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

    func sendResetPasswordCode(
        to email: String,
        completion: @escaping (Result<ForgetPasswordResponse, NetworkError>) -> Void
    ) {
        let forgotPasswordRequest = ForgotPasswordRequest(email: email)
        networkManager
            .performRequest(
                endpoint: AuthenticationEndpoint.forgotPassword,
                body: forgotPasswordRequest,
                responseType: ForgetPasswordResponse.self
            ) { result in
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

    func resetPassword(
        resetPasswordCode: String,
        newPassword: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        let resetPasswordRequest = ResetPasswordRequest(resetPasswordCode: resetPasswordCode, newPassword: newPassword)
        networkManager
            .performRequest(
                endpoint: AuthenticationEndpoint.resetPassword,
                body: resetPasswordRequest,
                responseType: EmptyResponse.self
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
