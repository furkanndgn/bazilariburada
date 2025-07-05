//
//  ProfileViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.06.2025.
//

import Foundation

final class ProfileViewModel {

    let userService: UserServiceProtocol
    let authenticationManager = AuthenticationManager.shared

    private(set) var userDetail: User?

    init(userService: UserService = UserService()) {
        self.userService = userService
    }

    func getProfile() async {
        let response = await userService.getUserProfile(with: authenticationManager.accessToken ?? "")
        guard let userData = response?.data else { return }
        userDetail = userData
    }

    func logout() {
        authenticationManager.logout()
    }
}
