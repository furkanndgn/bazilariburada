//
//  String+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 20.05.2025.
//

import Foundation

extension String {
    ///     Mask email for safety. Ex. a * * * * @gmail.com
    var maskedEmail: String {
        let parts = split(separator: "@")
        guard parts.count == 2 else { return self }
        let username = String(parts[0])
        let domain = String(parts[1])
        let firstChar = username.first.map { String($0) } ?? ""
        let mask = String(repeating: "*", count: max(0, username.count - 1))
        return "\(firstChar)\(mask)@\(domain)"
    }

    var maskedCardNumber: String {
        let mask = String(repeating: "*", count: count - 4)
        return "\(mask)\(suffix(4))"
    }

    var isTrimmedEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func isoDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }


    /// Convert date from strings formatted `yyyy-MM-dd`
    func orderDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
