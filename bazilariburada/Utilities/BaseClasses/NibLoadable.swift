//
//  NibLoadable.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import UIKit

protocol NibLoadable { }

extension NibLoadable where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

    static func loadFromNib() -> Self? {
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil).first as? Self
    }

    static func getNib() -> UINib? {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}
