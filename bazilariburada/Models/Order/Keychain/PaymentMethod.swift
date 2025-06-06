//
//  PaymentMethod.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import UIKit

struct PaymentMethod: Codable {
    var id = UUID()
    var brand: PaymentProvider
    let number: String
    let expireMonth: Int
    let expireYear: Int
    let securityCode: String
    var isSelected = false
}

enum PaymentProvider: Codable {
    case visa, masterCard, amex, discover, diners, jcb, unknown

    func brandIcon() -> UIImage? {
        switch self {
        case .visa:
            return UIImage(named: "Images/Logos/visa-logo")
        case .masterCard:
            return UIImage(named: "Images/Logos/mastercard-logo")
        case .amex:
            return UIImage(named: "Images/Logos/amex-logo")
        case .discover:
            return UIImage(named: "Images/Logos/discover-logo")
        case .diners:
            return UIImage(named: "Images/Logos/diners-logo")
        case .jcb:
            return UIImage(named: "Images/Logos/jcb-logo")
        case .unknown:
            return UIImage(systemName: "camera.metering.unknown")
        }
    }

    static func detectCardBrand(_ number: String) -> PaymentProvider {
        let cleaned = number.replacingOccurrences(of: " ", with: "")

        guard cleaned.count >= 4 else { return .unknown }

        if cleaned.hasPrefix("4") {
            return .visa
        }

        let two = Int(cleaned.prefix(2)) ?? 0
        let four = Int(cleaned.prefix(4)) ?? 0

        if (51...55).contains(two) || (2221...2720).contains(four) {
            return .masterCard
        }

        if cleaned.hasPrefix("34") || cleaned.hasPrefix("37") {
            return .amex
        }

        if cleaned.hasPrefix("6011") || cleaned.hasPrefix("65") ||
            (644...649).contains(Int(cleaned.prefix(3)) ?? 0) {
            return .discover
        }

        let three = Int(cleaned.prefix(3)) ?? 0
        if (300...305).contains(three) || cleaned.hasPrefix("36")
            || cleaned.hasPrefix("38") || cleaned.hasPrefix("39") {
            return .diners
        }

        if (3528...3589).contains(four) {
            return .jcb
        }
        return .unknown
    }
}
