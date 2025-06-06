//
//  CardValidator.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 5.06.2025.
//

import Foundation

enum CardValidator {
    static func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        for (idx, element) in digitStrings.enumerated() {
            guard let digit = Int(element) else { return false }
            if idx % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }

    static func cvvCheck(_ cvv: String, brand: PaymentProvider) -> Bool {
        guard cvv.allSatisfy({ $0.isNumber }) else { return false }
        switch brand {
        case .amex:
            return cvv.count == 4
        case .visa, .masterCard, .discover, .jcb, .diners:
            return cvv.count == 3
        default:
            return (3...4).contains(cvv.count)
        }
    }
}
