//
//  ViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import UIKit

class ViewController: UIViewController {

    let autService = AuthenticationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func testButton(_ sender: UIButton) {
        autService.register(username: "furkitolki", email: "furkndognn@gmail.com", password: "12345678")
    }
    
}

