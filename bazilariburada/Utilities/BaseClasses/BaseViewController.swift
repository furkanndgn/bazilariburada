//
//  BaseViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import UIKit

class BaseViewController: UIViewController, NibLoadable {

    init() {
        super.init(nibName: Self.nibName, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
