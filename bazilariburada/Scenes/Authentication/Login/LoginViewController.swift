//
//  LoginController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import UIKit
import Combine

final class LoginViewController: BaseViewController {

    private var viewModel: LoginViewModel



    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated: animated)
    }
}


