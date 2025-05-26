//
//  ResetPasswordRequest.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.03.2025.
//

import Foundation

struct ResetPasswordRequest: Encodable {
    let email: String
    let resetPasswordCode: String
    let newPassword: String
}
