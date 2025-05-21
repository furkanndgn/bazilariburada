//
//  File.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.03.2025.
//

import Foundation

protocol AuthenticationServiceProtocol {

    func registerUser(username: String, email: String, password: String) async -> Int?

    func activateAccount(email: String, activationCode: String) async -> Int?

    func loginUsing(username: String, password: String) async -> Int?

    func sendResetPasswordCode(to email: String) async -> String?

    func resetPassword(resetPasswordCode: String, newPassword: String) async -> String?
}
