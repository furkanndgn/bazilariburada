//
//  SplashViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 11.12.2024.
//

import UIKit

final class SplashViewController: BaseViewController {

    private let viewModel: SplashViewModel

    var onComplete: ((Bool) -> Void)?

    init(viewModel: SplashViewModel = SplashViewModel()) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            let isValid = await viewModel.validateTokens()
            onComplete?(isValid)
        }
    }
}
