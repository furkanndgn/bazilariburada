//
//  Constants.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import Foundation

enum Constants {
    enum String {
        static let empty = ""
    }

    enum Keychain {
        static let serviceIdentifier = "com.bazilariburada.auth"
        static let accessAccount = "accessToken"
        static let refreshAccount = "refreshToken"
    }
}

extension Constants.String {
    enum Title {
        static let app = "bazilariburada"
        static let productDescription = "Product Description"
        static let routeToLogin = "If you already have an account"
    }

    enum Error {
        static let defaultTitle = "Error"
        static let userExistsMessage = "User already exists"
    }

    enum Build {
        case stock(stock: Int)

        func string() -> String {
            switch self {
            case .stock(let stock):
                return "\(stock) in stock"
            }
        }
    }
}

