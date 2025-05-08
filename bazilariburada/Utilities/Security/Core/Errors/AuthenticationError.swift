//
//  AuthenticationError.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 6.05.2025.
//

import Foundation

enum AuthenticationError: Error {
    case tokenNotFound
    case refreshTokenExpired
    case refreshFailed(Error)
}
