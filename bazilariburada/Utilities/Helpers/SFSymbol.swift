//
//  SFSymbol.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.04.2025.
//

import UIKit

enum SFSymbol: String {
    case starFill = "star.fill"
    case halfStarFill = "star.leadinghalf.filled"
    case star = "star"
    case chevronRight = "chevron.right"

    func image(with tintColor: UIColor) -> UIImage? {
        UIImage(systemName: self.rawValue)?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
    }
}
