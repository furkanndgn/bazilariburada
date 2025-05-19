//
//  UserExistsPopup.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 17.05.2025.
//

import Foundation

/// Warns the user that an account with these credentials already exists.
class UserExistsPopup: ErrorPopupViewController {
    override func viewDidLoad() {
        configurePopup(
            title: Constants.String.Error.defaultTitle,
            message: Constants.String.Error.userExistsMessage
        )
        super.viewDidLoad()
    }
}
