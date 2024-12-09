//
//  AuthenticationService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

// For endpoints in Authentication collection
class AuthenticationService: ObservableObject {
    
    private let authKeyword = "/auth"
    private let networkManager = NetworkManager.shared
    private var authenticationSubscription: AnyCancellable?
    @Published var registerData: RegisterResponseData?
    @Published var loginData: LoginResponseData?
    @Published var forgetPasswordData: ForgetPasswordResponseData?
    @Published var activateAccountMessage: String?
    @Published var resetPasswordMessage: String?
    
    func register(username: String, email: String, password: String) {
        let body = ["username": username, "email": email, "password": password]
        authenticationSubscription = networkManager.performRequest(endpoint: "\(authKeyword)/register",
                                                                   method: .POST, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.registerData = response.data
                self?.authenticationSubscription?.cancel()
            })
    }
    
    func activateAccount(email: String, activationCode: String) {
        let body = ["email": email, "activationCode": activationCode]
        authenticationSubscription = networkManager.performRequest(endpoint: "\(authKeyword)/activate",
                                                                   method: .PATCH, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.activateAccountMessage = response.message
                self?.authenticationSubscription?.cancel()
            })
    }

    func login(username: String, password: String) {
        let body = ["username": username, "password": password]
        authenticationSubscription = networkManager.performRequest(endpoint: "\(authKeyword)/login",
                                                                   method: .POST, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.loginData = response.data
                self?.authenticationSubscription?.cancel()
            })
    }
    
    func getResetPasswordCode(email: String) {
        let body = ["email": email]
        authenticationSubscription = networkManager.performRequest(endpoint: "\(authKeyword)/forgot-password",
                                                                   method: .POST, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.forgetPasswordData = response.data
                self?.authenticationSubscription?.cancel()
            })
    }
    
    func resetPassword(securityCode: String, newPassword: String) {
        let body = ["resetPasswordCode": securityCode, "newPassword:": newPassword]
        authenticationSubscription = networkManager.performRequest(endpoint: "\(authKeyword)/reset-password",
                                                                   method: .POST, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                self?.resetPasswordMessage = response.message
                self?.authenticationSubscription?.cancel()
            })
    }
}
