//
//  TestViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import UIKit
import Combine

final class TestViewController: BaseViewController {

    let authService = AuthenticationService()
    let cartService = CartService()
    let orderService = OrderService()
    let productService = ProductService()
    let reviewService = ReviewService()
    let userService = UserService()
    let authManager = AuthenticationManager.shared
    var userToken: String = ""
    var allProducts: AllProductsResponse? = nil
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        productService.allProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let data):
                    self?.allProducts = data
                    print(data.products.count)
                case .failure(let networkError):
                    print(String(describing: networkError.localizedDescription))
                }
            }
            .store(in: &cancellables)
    }

//    MARK: KeychainManagerTest
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let accessTokenAccount = Constants.Keychain.accessAccount
    private let refreshTokenAccount = Constants.Keychain.refreshAccount

    func login(with username: String =  "furkido", password: String = "12345678") {
        authService.loginUsing(username: username, password: password) { result in
            switch result {
            case .success(let data):
                Task {
                    await self.authManager.saveNewTokens(
                        accessToken: data.accessToken,
                        accessTokenExpiresAt: Date().addingTimeInterval(86400),
                        refreshToken: data.refreshToken,
                        refreshTokenExpiresAt: Date().addingTimeInterval(604800)
                    )
                }
            case .failure(let networkError):
                print(networkError.localizedDescription)
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        login()
    }

    @IBAction func loadButtonTapped(_ sender: Any) {
        Task {
            let access: String? = await authManager.getValidAccessToken()
            print("access: \(access ?? "no access")")
        }
        let refresh: TokenInfo? = try? KeychainManager.shared.load(service: serviceIdentifier, account: refreshTokenAccount)
        print("refresh: \(refresh?.token ?? "no refresh")")

    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        try? KeychainManager.shared.delete(service: serviceIdentifier, account: accessTokenAccount)
    }
}

