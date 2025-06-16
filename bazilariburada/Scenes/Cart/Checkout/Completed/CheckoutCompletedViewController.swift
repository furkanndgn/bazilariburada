//
//  CheckoutCompletedViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 16.06.2025.
//

import UIKit
import Lottie
import SnapKit

final class CheckoutCompletedViewController: BaseViewController {

    @IBOutlet weak var animationContainer: UIView!

    private var animationView: LottieAnimationView?

    var buttonTapped: Completion?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @IBAction func homeButtonTapped(_ sender: Any) {
        buttonTapped?()
    }
}


// MARK: - Setup UI
private extension CheckoutCompletedViewController {

    func setupView() {
        animationContainer.subviews.forEach { $0.removeFromSuperview() }
        let animationView = LottieAnimationView(name: "OrderSuccess")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationContainer.addSubview(animationView)
        self.animationView = animationView

        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animationView.play()
    }
}
