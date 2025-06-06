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
    case heart = "heart"
    case heartFill = "heart.fill"
    case house = "house"
    case cart = "cart"
    case person = "person"
    case heartText = "heart.text.square"

    func image(with tintColor: UIColor) -> UIImage? {
        UIImage(systemName: self.rawValue)?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
    }
}
