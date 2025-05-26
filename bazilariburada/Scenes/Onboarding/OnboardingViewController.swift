//
//  OnboardingViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 12.05.2025.
//

import UIKit

final class OnboardingViewController: BaseViewController, RouteEmitting {

    var onRoute: ((Route) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        onRoute?(.toRegisterScene(self))
    }
}

extension OnboardingViewController {
    enum Route {
        case toRegisterScene(BaseViewController)
    }
}
