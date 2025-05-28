//
//  AuthenticationManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 5.05.2025.
//

import Foundation

final class AuthenticationManager {

    static let shared = AuthenticationManager()

    private let authenticationService: AccessTokenRefreshProtocol = AuthenticationService()
    private let keychainManager = KeychainManager.shared
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let accessTokenAccount = Constants.Keychain.accessAccount
    private let refreshTokenAccount = Constants.Keychain.refreshAccount

    var accessToken: String? {
        get async {
            await getValidAccessToken()
        }
    }

    private init() { }

    func saveNewTokens(
        _ accessToken: String,
        accessTokenExpiresAt: Date,
        _ refreshToken: String,
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

    func logout() {
        do {
            try keychainManager.delete(service: serviceIdentifier, account: accessTokenAccount)
            try keychainManager.delete(service: serviceIdentifier, account: refreshTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


private extension AuthenticationManager {

    func getValidAccessToken() async -> String? {
        var accessTokenInfo: TokenInfo? = nil
        do {
            accessTokenInfo = try keychainManager.load(service: serviceIdentifier, account: accessTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }

        if let accessTokenInfo, accessTokenInfo.expiresAt > Date().addingTimeInterval(3600) {
            return accessTokenInfo.token
        }

        guard let refreshToken = getValidRefreshToken() else {
            logout()
            return nil
        }

        await performRefresh(with: refreshToken)

        do {
            accessTokenInfo = try keychainManager.load(service: serviceIdentifier, account: accessTokenAccount)
            if let accessTokenInfo, accessTokenInfo.expiresAt > Date().addingTimeInterval(3600) {
                return accessTokenInfo.token
            }
        } catch {
            print(error.localizedDescription)
        }

        logout()
        return nil
    }

    func getValidRefreshToken() -> String? {
        var refreshTokenInfo: TokenInfo? = nil
        do {
            refreshTokenInfo = try keychainManager.load(service: serviceIdentifier, account: refreshTokenAccount)
        } catch let error {
            print(error.localizedDescription)
        }
        guard let refreshTokenInfo, refreshTokenInfo.expiresAt > Date().addingTimeInterval(3600) else { return nil }
        return refreshTokenInfo.token
    }

    func performRefresh(with refreshToken: String) async {
        let response = await authenticationService.refreshAccessToken(with: refreshToken)
        if response?.status == 200, let data = response?.data, let date = response?.timestamp.isoDate() {
            let accessTokenExpiresAt = date.addingTimeInterval(86400)
            let refreshTokenExpiresAt = date.addingTimeInterval(604800)
            saveNewTokens(
                data.accessToken,
                accessTokenExpiresAt: accessTokenExpiresAt,
                data.refreshToken,
                refreshTokenExpiresAt: refreshTokenExpiresAt
            )
        }
    }
}
