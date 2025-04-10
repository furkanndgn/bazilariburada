//
//  NibLoadable.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self? {
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil).first as? Self
    }
}

extension NibLoadable {
    static var nibName: String {
            return String(describing: self)
        }
}
