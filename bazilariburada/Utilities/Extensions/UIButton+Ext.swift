//
//  UIButton+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 14.06.2025.
//

import UIKit
import SnapKit

extension UIButton {
    private struct AssociatedKeys {
        static var activityIndicator: UInt8 = 0
    }

    var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showLoading(_ loading: Bool) {
        if loading {
            isEnabled = false
            setTitleColor(.clear, for: .normal)
            if activityIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .medium)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                addSubview(indicator)
                indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                activityIndicator = indicator
            }
            activityIndicator?.startAnimating()
        } else {
            isEnabled = true
            setTitleColor(nil, for: .normal) // use original color
            activityIndicator?.stopAnimating()
        }
    }
}
