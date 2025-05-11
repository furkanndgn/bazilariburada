//
//  AuthenticationManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 5.05.2025.
//

import Foundation

actor AuthenticationManager {

    static let shared = AuthenticationManager()

    private let authService: AccessTokenRefreshProtocol = AuthenticationService()
    private let keychainManager = KeychainManager.shared
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let accessTokenAccount = Constants.Keychain.accessAccount
    private let refreshTokenAccount = Constants.Keychain.refreshAccount

    var accessToken: String? {
        getValidAccessToken()
    }

    private init() { }

    func saveNewTokens(
        accessToken: String,
        accessTokenExpiresAt: Date,
        refreshToken: String,
        refreshTokenExpiresAt: Date
    ) {
        let accessTokenInfo = TokenInfo(token: accessToken, expiresAt: accessTokenExpiresAt)
        let refreshTokenInfo = TokenInfo(token: refreshToken, expiresAt: refreshTokenExpiresAt)

        do {
            try keychainManager.save(accessTokenInfo, service: serviceIdentifier, account: accessTokenAccount)
            try keychainManager.save(refreshTokenInfo, service: serviceIdentifier, account: refreshTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func validateTokens() async {
        guard accessToken == nil else { return }

        guard let refreshToken = getValidRefreshToken() else {
            logout()
            return
        }

        do {
            try await performRefresh(with: refreshToken)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func logout() {
        clearTokens()
    }
}


private extension AuthenticationManager {

    func getValidAccessToken() -> String? {
        var accessTokenInfo: TokenInfo? = nil
        do {
            accessTokenInfo = try keychainManager.load(service: serviceIdentifier, account: accessTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }

        guard let accessTokenInfo, accessTokenInfo.expiresAt > Date().addingTimeInterval(3600) else {
            return nil
        }

        return accessTokenInfo.token
    }

    func getValidRefreshToken() -> String? {
        var refreshTokenInfo: TokenInfo? = nil
        do {
            refreshTokenInfo = try keychainManager.load(service: serviceIdentifier, account: refreshTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }
        guard let refreshTokenInfo, refreshTokenInfo.expiresAt > Date().addingTimeInterval(60) else { return nil }
        return refreshTokenInfo.token
    }

    func performRefresh(with refreshToken: String) async throws {
        let authService = self.authService
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: NSError(domain: "SelfDeallocated", code: 1))
                return
            }
            authService.refreshAccessToken(with: refreshToken) { result in
                switch result {
                case .success(let data):
                    Task {
                        await self.saveNewTokens(
                            accessToken: data.accessToken,
                            accessTokenExpiresAt: Date().addingTimeInterval(86400),
                            refreshToken: data.refreshToken,
                            refreshTokenExpiresAt: Date().addingTimeInterval(604800)
                        )
                        continuation.resume()
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func clearTokens() {
        do {
            try keychainManager.delete(service: serviceIdentifier, account: accessTokenAccount)
            try keychainManager.delete(service: serviceIdentifier, account: refreshTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
