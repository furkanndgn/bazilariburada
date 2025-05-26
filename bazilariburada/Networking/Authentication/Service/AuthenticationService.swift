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

    func registerUser(username: String, email: String, password: String) async -> Int? {
        let registerRequest = RegisterRequest(username: username, email: email, password: password)
        var statusCode: Int?
        do {
            let response: APIResponse<RegisterResponse?> = try await networkManager.performRequest(
                endpoint: AuthenticationEndpoint.register,
                body: registerRequest
            )
            statusCode = response.status
        } catch let error as NetworkError {
            switch error {
            case .clientError(let response):
                statusCode = response.status
            default:
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        return statusCode
    }

    func activateAccount(email: String, activationCode: String) async -> Int? {
        let activationRequest = ActivateAccountRequest(email: email, activationCode: activationCode)
        var statusCode: Int?
        do {
            let response: APIResponse<EmptyResponse> = try await networkManager.performRequest(
                endpoint: AuthenticationEndpoint.activateAccount,
                body: activationRequest
            )
            statusCode = response.status
        } catch let error {
            print(error.localizedDescription)
        }
        return statusCode
    }

    func loginUsing(username: String, password: String) async -> APIResponse<LoginResponse>? {
        let loginRequest = LoginRequest(username: username, password: password)
        var response: APIResponse<LoginResponse>?
        do {
            response = try await networkManager
                .performRequest(endpoint: AuthenticationEndpoint.login, body: loginRequest)
        } catch let error {
            print(error)
        }
        return response
    }

    func refreshAccessToken(with refreshToken: String) async -> APIResponse<RefreshAccessTokenResponse>? {
        let refreshTokenRequest = RefreshTokenRequest(refreshToken: refreshToken)
        do {
            return try await networkManager
                .performRequest(
                    endpoint: AuthenticationEndpoint.refreshAccessToken,
                    body: refreshTokenRequest
                )
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    func sendResetPasswordCode(to email: String) async -> Int? {
        let forgotPasswordRequest = ForgotPasswordRequest(email: email)
        var statusCode: Int?
        do {
            let response: APIResponse<ForgetPasswordResponse> = try await networkManager.performRequest(
                endpoint: AuthenticationEndpoint.forgotPassword,
                body: forgotPasswordRequest
            )
            statusCode = response.status
        } catch let error {
            print(error.localizedDescription)
        }
        return statusCode
    }

    func resetPassword(email: String, resetPasswordCode: String, newPassword: String) async -> Int? {
        let resetPasswordRequest = ResetPasswordRequest(email: email, resetPasswordCode: resetPasswordCode, newPassword: newPassword)
        var statusCode: Int?
        do {
            let response: APIResponse<EmptyResponse> = try await networkManager.performRequest(
                endpoint: AuthenticationEndpoint.resetPassword,
                body: resetPasswordRequest
            )
            statusCode = response.status
        } catch let error {
            print(error.localizedDescription)
        }
        return statusCode
    }
}
