//
//  AccessTokenRefreshProtocol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.05.2025.
//

import Foundation

protocol AccessTokenRefreshProtocol {
    func refreshAccessToken(with refreshToken: String) async -> APIResponse<RefreshAccessTokenResponse>?
}
