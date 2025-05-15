//
//  EmailValidator.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 14.05.2025.
//

import Foundation

enum EmailValidationError: Error {
    case empty
    case invalidFormat
    case domainNotAllowed
}

enum EmailValidator {

    static func validateEmail(_ email: String) throws(EmailValidationError) {
        if email.isEmpty {
            throw .empty
        }

        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)

        if !emailPredicate.evaluate(with: email) {
            throw .invalidFormat
        }
    }
}
