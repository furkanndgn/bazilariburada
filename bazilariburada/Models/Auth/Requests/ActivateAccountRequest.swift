//
//  ActivateAccountRequest.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.03.2025.
//

import Foundation

struct ActivateAccountRequest: Encodable {
    let email: String
    let activationCode: String
}
