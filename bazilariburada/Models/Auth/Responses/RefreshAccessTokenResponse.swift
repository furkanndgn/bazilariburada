//
//  RefreshAccessToken.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import Foundation

struct RefreshAccessTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
