//
//  RefreshAccessTokenData.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import Foundation

struct RefreshAccessTokenResponseData: Decodable {
    let accessToken: String
    let refreshToken: String
}
