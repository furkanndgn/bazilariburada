//
//  KeychainError.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 6.05.2025.
//

import Foundation

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}
