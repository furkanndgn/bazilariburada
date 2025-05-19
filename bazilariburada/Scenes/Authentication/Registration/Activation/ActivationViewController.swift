//
//  ActivationViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import UIKit

class ActivationViewController: BaseViewController, RouteEmitting {

    var onRoute: ((Route) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - Setup Routing
extension ActivationViewController {
    enum Route {
        
    }
}
