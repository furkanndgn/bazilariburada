//
//  SignInViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 15.11.2024.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    private var viewModel: AuthViewModel
    @Published var password: String = ""
    @Published var username: String = ""
    
    private var validatedPassword: AnyPublisher<String?, Never> {
        $password
            .map { password in
                guard password.count > 8 else { return nil }
                return password
            }
            .eraseToAnyPublisher()
    }
    
    private var validatedUsername: AnyPublisher<String?, Never> {
        return $username
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { username in
                !username.isEmpty ? nil : username
            }
            .eraseToAnyPublisher()
    }
    
    private var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        validatedUsername
            .combineLatest(validatedPassword)
            .map { username, password in
                guard let uname = username, let pword = password else { return nil }
                return (uname, pword)
            }
            .eraseToAnyPublisher()
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    init(viewModel: AuthViewModel = AuthViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "SignInViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Activation Functions
    @IBAction func pushTestView(_ sender: UIButton) {
        navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        print("loginButton tapped.")
    }
        
    @IBAction func usernameChanged(_ sender: UITextField) {
        username = sender.text ?? ""
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
    }
}
