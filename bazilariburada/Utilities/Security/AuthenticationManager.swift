//
//  AuthenticationManager.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 5.05.2025.
//

import Foundation

//actor AuthenticationManager {
//
//    private let authService: AccessTokenRefreshProtocol
//    static let shared = AuthenticationManager()
//
//    private let serviceIdentifier = "com.bazilariburada.auth"
//    private let accessTokenAccount = "accessToken"
//    private let refreshTokenAccount = "refreshToken"
//
//    private var refreshTask: Task<String, Error>?
//
//    private(set) var currentAccessToken: String?
//
//    private init() {
//        self.authService = AuthenticationService()
//    }
//
//    func saveTokens(
//        accessToken: String,
//        accessExpiresAt: Date,
//        refreshToken: String,
//        refreshExpiresAt: Date
//    ) throws {
//        let accessTokenInfo = TokenInfo(token: accessToken, expiresAt: accessExpiresAt)
//        let refreshTokenInfo = TokenInfo(token: refreshToken, expiresAt: refreshExpiresAt)
//        let accessTokenData = try JSONEncoder().encode(accessTokenInfo)
//        let refreshTokenData = try JSONEncoder().encode(refreshTokenInfo)
//
//        try KeychainManager.shared.save(accessTokenData, service: serviceIdentifier, account: accessTokenAccount)
//        try KeychainManager.shared.save(refreshTokenData, service: serviceIdentifier, account: refreshTokenAccount)
//    }
//
//    func getValidAccessToken() async throws -> String {
//        do {
//            if let accessToken = try loadAccessToken(), accessToken.expiresAt > Date().addingTimeInterval(3600) {
//                currentAccessToken = accessToken.token
//                return accessToken.token
//            }
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//        if let refreshTask = refreshTask {
//            return try await refreshTask.value
//        }
//
//        guard let refreshToken = try loadRefreshToken(), refreshToken.expiresAt > Date() else {
//            clearTokens()
//            throw AuthenticationError.refreshTokenExpired
//        }
//
//        let task = Task<String, Error> {
//            defer { refreshTask = nil }
//            do {
//                let newTokens = try await performRefresh(with: refreshToken.token)
//                try saveTokens(
//                    accessToken: newTokens.accessToken,
//                    accessExpiresAt: newTokens.accessExpiresAt,
//                    refreshToken: newTokens.refreshToken,
//                    refreshExpiresAt: newTokens.refreshExpiresAt
//                )
//                currentAccessToken = newTokens.accessToken
//                return newTokens.accessToken
//            } catch {
//                clearTokens()
//                throw AuthenticationError.refreshFailed(error)
//            }
//        }
//
//        self.refreshTask = task
//        return try await task.value
//    }
//
//    func logout() {
//        clearTokens()
//        currentAccessToken = nil
//    }
//}
//
//
//private extension AuthenticationManager {
//
//    func loadAccessToken() throws -> TokenInfo? {
//        guard let tokenInfo: TokenInfo = try KeychainManager.shared.load(
//            service: serviceIdentifier,
//            account: accessTokenAccount
//        ) else {
//            throw AuthenticationError.tokenNotFound
//        }
//        print(tokenInfo.token)
//        return tokenInfo
//    }
//
//    func loadRefreshToken() throws -> TokenInfo? {
//        guard let tokenInfo: TokenInfo = try KeychainManager.shared.load(
//            service: serviceIdentifier,
//            account: refreshTokenAccount
//        ) else {
//            throw AuthenticationError.tokenNotFound
//        }
//        return tokenInfo
//    }
//
//    func performRefresh(with refreshToken: String) async throws -> (
//        accessToken: String,
//        refreshToken: String,
//        accessExpiresAt: Date,
//        refreshExpiresAt: Date
//    ) {
//        return try await withCheckedThrowingContinuation { continuation in
//            authService.refreshAccessToken(with: refreshToken) { result in
//                switch result {
//                case .success(let data):
//                    continuation.resume(returning: (
//                        data.accessToken,
//                        data.refreshToken,
//                        Date().addingTimeInterval(86400),
//                        Date().addingTimeInterval(604800)
//                    ))
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//
//    func clearTokens() {
//        do {
//            try KeychainManager.shared.delete(service: serviceIdentifier, account: accessTokenAccount)
//            try KeychainManager.shared.delete(service: serviceIdentifier, account: refreshTokenAccount)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//}

actor AuthenticationManager {

    static let shared = AuthenticationManager()

    private let authService: AccessTokenRefreshProtocol = AuthenticationService()
    private let keychainManager = KeychainManager.shared
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let accessTokenAccount = Constants.Keychain.accessAccount
    private let refreshTokenAccount = Constants.Keychain.refreshAccount

//    var accessToken: String? {
//        getValidAccessToken()
//    }

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


    func getValidAccessToken() async -> String?  {
        var accessTokenInfo: TokenInfo? = nil
        do {
            accessTokenInfo = try keychainManager.load(
                service: serviceIdentifier,
                account: accessTokenAccount
            )
        } catch let error {
            print(error.localizedDescription)
        }

        if let accessTokenInfo, accessTokenInfo.expiresAt > Date().addingTimeInterval(3600) {
            return accessTokenInfo.token
        } else {
            guard let refreshToken = getValidRefreshToken() else {
                clearTokens()
                return nil
            }

            do {
                try await performRefresh(with: refreshToken)
                return await getValidAccessToken()
            } catch let error {
                print(error.localizedDescription)
                logout()
                return nil
            }
        }
    }

    func logout() {
        clearTokens()
    }
}


private extension AuthenticationManager {

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

    //    func performRefresh(with refreshToken: String, completion: @escaping (String?) -> Void) {
    //        authService.refreshAccessToken(with: refreshToken) { [weak self] result in
    //            switch result {
    //            case .success(let data):
    //                Task {
    //                    await self?.saveNewTokens(
    //                        accessToken: data.accessToken,
    //                        accessTokenExpiresAt: Date().addingTimeInterval(86400),
    //                        refreshToken: data.refreshToken,
    //                        refreshTokenExpiresAt: Date().addingTimeInterval(604800)
    //                    )
    //                    completion(data.accessToken)
    //                }
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //                completion(nil)
    //            }
    //        }
    //    }

    func performRefresh(with refreshToken: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            authService.refreshAccessToken(with: refreshToken) { result in
                switch result {
                case .success(let data):
                    self.saveNewTokens(
                        accessToken: data.accessToken,
                        accessTokenExpiresAt: Date().addingTimeInterval(86400),
                        refreshToken: data.refreshToken,
                        refreshTokenExpiresAt: Date().addingTimeInterval(604800)
                    )
                    continuation.resume()
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


