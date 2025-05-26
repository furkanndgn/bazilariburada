//
//  NavigationController+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 21.05.2025.
//

import UIKit

/// Adds push and pop methods to UINavigationController for cross-dissolve (fade) transition animations,
/// providing a smoother visual effect when moving between peer screens.
extension UINavigationController {
    func pushWithFade(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        view.layer.add(transition, forKey: kCATransition)
        pushViewController(viewController, animated: false)
    }

    func popWithFade() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        view.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
