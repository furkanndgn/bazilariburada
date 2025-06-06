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
}

enum CredentialValidator {
    
    static func validateEmail(_ email: String) throws {
        if email.isEmpty {
            throw EmailValidationError.empty
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            throw EmailValidationError.invalidFormat
        }
    }
    
    static func validatePassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        return true
    }
    
    static func validateUsername(_ username: String) -> Bool {
        guard username.count >= 3, username.count <= 20 else { return false }
        return true
    }

    static func validateFullname(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: " ").filter { !$0.isEmpty }
        return parts.count >= 2 && parts.allSatisfy { $0.rangeOfCharacter(from: .letters) != nil }
    }
}
