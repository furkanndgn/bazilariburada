//
//  String+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.05.2025.
//

import Foundation

extension String {
    var maskedEmail: String {
        let parts = split(separator: "@")
        guard parts.count == 2 else { return self }
        let username = String(parts[0])
        let domain = String(parts[1])
        let firstChar = username.first.map { String($0) } ?? ""
        let mask = String(repeating: "*", count: max(0, username.count - 1))
        return "\(firstChar)\(mask)@\(domain)"
    }
}
