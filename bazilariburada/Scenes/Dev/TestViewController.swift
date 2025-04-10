//
//  TestViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import UIKit
import Combine

class TestViewController: BaseViewController {

    let autService = AuthenticationService()
    let cartService = CartService()
    let orderService = OrderService()
    let productService = ProductService()
    let reviewService = ReviewService()
    let userService = UserService()
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

    ///MARK: Authentication testing
    @IBAction func loginPressed(_ sender: UIButton) {
        autService.loginUsing(username: "furkido", password: "12345678") { result in
            switch result {
            case .success(let data):
                print(data.username)
            case .failure(let networkError):
                print(String(describing: networkError.localizedDescription))
            }
        }
    }
    @IBAction func getAllProductPressed(_ sender: UIButton) {
        productService.getAllProducts()
    }
}

