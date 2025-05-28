//
//  Numeric+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 28.05.2025.
//

import Foundation

extension Numeric {
    func asCurrency(locale: Locale = Locale.current) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(for: self)
    }
}
