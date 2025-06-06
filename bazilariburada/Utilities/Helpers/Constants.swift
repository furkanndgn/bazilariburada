//
//  Constants.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import Foundation
enum Constants {
    enum Keychain {
        static let serviceIdentifier = "com.bazilariburada.auth"
        static let accessAccount = "accessToken"
        static let refreshAccount = "refreshToken"
        static let paymentAccount = "paymentMethod"
        static let addressAccount = "address"
    }

    enum Text {
        enum Title {
            static let mainApp = "bazilariburada"
            static let productDescription = "Product Description"
            static let email = "Email"
            static let username = "Username"
            static let password = "Password"
            static let securityCode = "Security Code"
        }

        enum Placeholder {
            static let email = "Enter your email address"
            static let username = "Enter your username"
            static let password = "Enter your password"
            static let securityCode = "Enter code sent to your email"
        }

        enum Error {
            static let defaultTitle = "Error"
            static let userExists = "User already exists"
        }
    }

    enum Formatter {
        static func stock(_ stock: Int) -> String {
            return "\(stock) in stock"
        }
        static func activationMessage(_ email: String) -> String {
            let maskedEmail = email.maskedEmail
            return "Enter 6-digit code, sent to \(maskedEmail))"
        }
    }
}
