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
    let cartService = CartService.shared
    let orderService = OrderService()
    let productService = ProductService()
    let reviewService = ReviewService()
    let userService = UserService()
    let authManager = AuthenticationManager.shared
    var userToken: String = ""
    var allProducts: [Product]? = nil
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubscribers()
    }


//    MARK: - KeychainManagerTest
    private let serviceIdentifier = Constants.Keychain.serviceIdentifier
    private let accessTokenAccount = Constants.Keychain.accessAccount
    private let refreshTokenAccount = Constants.Keychain.refreshAccount

    var products: APIResponse<AllProductsResponse>? = nil


    @IBAction func saveButtonTapped(_ sender: Any) {

    }

    @IBAction func loadButtonTapped(_ sender: Any) {

    }

    @IBAction func deleteButtonTapped(_ sender: Any) {

    }


    func addSubscribers() {
        productService.allProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.allProducts = response?.data?.products
            }
            .store(in: &cancellables)
    }
}
