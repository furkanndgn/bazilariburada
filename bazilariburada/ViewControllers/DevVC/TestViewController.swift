//
//  TestViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import UIKit

class TestViewController: UIViewController {

    let autService = AuthenticationService()
    let cartService = CartService()
    let orderService = OrderService()
    let productService = ProductService()
    let reviewService = ReviewService()
    let userService = UserService()
    var userToken: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    ///MARK: Authentication testing
    @IBAction func testRegister(_ sender: UIButton) {
        autService.register(username: "furkitolki", email: "furkndognn@gmail.com", password: "12345678")
    }
    
    @IBAction func testActivate(_ sender: UIButton) {
        autService.activateAccount(email: "furkndognn@gmail.com", activationCode: "123123")
    }
    
    @IBAction func testLogin(_ sender: UIButton) {
        autService.login(username: "furkido", password: "12345678")
        userToken = autService.loginData?.accessToken ?? ""
        print(userToken)
    }
   
    @IBAction func testforget(_ sender: UIButton) {
        autService.getResetPasswordCode(email: "furkndognn@gmail.com")
    }
    
    @IBAction func testReset(_ sender: UIButton) {
        autService.resetPassword(securityCode: "123512", newPassword: "12345678")
    }
    
    ///MARK: Cart Testing
    @IBAction func testGetCart(_ sender: UIButton) {
        cartService.getUsersCart(token: userToken)
    }
    
    @IBAction func testAddItem(_ sender: UIButton) {
        cartService.addItemToCart(token: userToken, productID: "672ca178803e6ff577ae0b39", quantity: 3)
    }
    
    @IBAction func testUpdateQuantity(_ sender: UIButton) {
        cartService.updateCartItemQuantity(token: userToken, productID: "672ca178803e6ff577ae0b39", quantity: 5)
    }
    
    @IBAction func testRemoveItem(_ sender: UIButton) {
        cartService.removeItemFromCart(token: userToken, productID: "672ca178803e6ff577ae0b39")
    }
    
    @IBAction func testClearCart(_ sender: UIButton) {
        cartService.clearCartItems(token: userToken)
    }
    
    ///MARK: Order Testing
    @IBAction func testPlaceOrder(_ sender: UIButton) {
        orderService.placeAnOrder(token: userToken)
    }
    
    @IBAction func testGetOrderByID(_ sender: UIButton) {
        orderService.getUsersOrderByID(token: userToken, orderID: orderService.placedOrder?.orderID ?? "")
    }
    
    @IBAction func testGetAllOrders(_ sender: UIButton) {
        orderService.getUsersAllOrders(token: userToken)
    }
    
    ///MARK: Product Testing
    @IBAction func testGetAllProducts(_ sender: UIButton) {
        productService.getAllProducts()
    }
    
    @IBAction func testGetByID(_ sender: UIButton) {
        productService.getProductByID(productID: "672ca178803e6ff577ae0b3a")
    }
    
    ///MARK: Review Testing
    @IBAction func testGetProductReviews(_ sender: UIButton) {
        reviewService.getProductReviews(productID: "672ca178803e6ff577ae0b3a")
    }
    
    @IBAction func testAddReview(_ sender: UIButton) {
        reviewService.addProductReview(token: userToken, productID: "672ca178803e6ff577ae0b3a",
                                       comment: "stephen curry how I ball", rating: 5)
    }
    
    @IBAction func testRemoveReview(_ sender: UIButton) {
        reviewService.deleteUserReview(token: userToken, productID: "672ca178803e6ff577ae0b3a")
    }
    
    ///MARK: User Testing
    @IBAction func testGetProfile(_ sender: UIButton) {
        userService.getUserProfile(token: userToken)
    }
    
    @IBAction func testUpdateProfile(_ sender: UIButton) {
        userService.updateUserProfile(token: userToken, username: "furkido", password: "12345678")
    }
}

