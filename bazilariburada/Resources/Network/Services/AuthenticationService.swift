//
//  AuthenticationService.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 18.11.2024.
//

import Foundation
import Combine

// For endpoints in Authentication collection
class AuthenticationService {
    
    let authKeyword = "/auth"
    
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var registerData: RegisterResponseData?
    @Published var loginData: LoginResponseData?
    @Published var forgotPasswordData: ForgotPasswordResponseData?
    
    func register(username: String, email: String, password: String) {
        let body = ["username": username, "email": email, "password": password]
        networkManager.request(endpoint: "\(authKeyword)/register", method: .POST, body: body)
            .decode(type: ApiResponse<RegisterResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message) // for development purposes
                self?.registerData = response.data
            })
            .store(in: &cancellables)
    }
    
    func activateAccount(email: String, activationCode: String) {
        let body = ["email": email, "activationCode": activationCode]
        networkManager.request(endpoint: "\(authKeyword)/activate", method: .PATCH, body: body)
            .decode(type: ApiResponse<EmptyResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { response in
                print(response.message)
            })
            .store(in: &cancellables)
    }

    func login(username: String, password: String) {
        let body = ["username": username, "password": password]
        networkManager.request(endpoint: "\(authKeyword)/login", method: .POST, body: body)
            .decode(type: ApiResponse<LoginResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message) // for development purposes
                self?.loginData = response.data
            })
            .store(in: &cancellables)
    }
    
    func forgetPassword(email: String) {
        let body = ["email": email]
        networkManager.request(endpoint: "\(authKeyword)/forgot-password", method: .POST, body: body)
            .decode(type: ApiResponse<ForgotPasswordResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] response in
                print(response.message)
                self?.forgotPasswordData = response.data
            })
            .store(in: &cancellables)
    }
    
    func resetPassword(resetPasswordCode: String, newPassword: String) {
        let body = ["resetPasswordCode": resetPasswordCode, "newPassword:": newPassword]
        networkManager.request(endpoint: "\(authKeyword)/reset-password", method: .POST, body: body)
            .decode(type: ApiResponse<EmptyResponseData>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { response in
                print(response.message)
            })
            .store(in: &cancellables)
    }
}
