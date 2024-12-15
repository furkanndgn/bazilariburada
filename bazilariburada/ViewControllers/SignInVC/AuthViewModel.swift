//
//  SignInViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

class AuthViewModel {
    
    private let authService = AuthenticationService()
    private var cancellables = Set<AnyCancellable>()
    @Published var registerData: RegisterResponseData?
    @Published var loginData: LoginResponseData?
    @Published var forgetPassword: ForgetPasswordResponseData?
    @Published var accActivationMessage: String?
    @Published var resetPasswordMessage: String?
    
    init() {
        addSubscribers()
    }
    
    func login(username: String, password: String) {
        authService.login(username: username, password: password)
    }
    
    func register(username: String, email: String, password: String) {
        authService.register(username: username, email: email, password: password)
    }
    
    func activateAccount(email: String, activationCode: String) {
        authService.activateAccount(email: email, activationCode: activationCode)
    }
    
    func getResetPasswordCode(email: String) {
        authService.getResetPasswordCode(email: email)
    }
    
    func resetPassword(securityCode: String, newPassword: String) {
        authService.resetPassword(securityCode: securityCode, newPassword: newPassword)
    }
    
    private func addSubscribers() {
        authService.$registerData
            .sink { [weak self] returnedData in
                self?.registerData = returnedData
            }
            .store(in: &cancellables)
        authService.$loginData
            .sink { [weak self] returnedData in
                self?.loginData = returnedData
                UserDefaults.standard.set(returnedData?.refreshToken, forKey: "refreshToken")
            }
            .store(in: &cancellables)
        authService.$forgetPasswordData
            .sink { [weak self] returnedData in
                self?.forgetPassword = returnedData
            }
            .store(in: &cancellables)
        authService.$activateAccountMessage
            .sink { [weak self] returnedData in
                self?.accActivationMessage = returnedData
            }
            .store(in: &cancellables)
        authService.$resetPasswordMessage
            .sink { [weak self] returnedData in
                self?.resetPasswordMessage = returnedData
            }
            .store(in: &cancellables)
    }
}

