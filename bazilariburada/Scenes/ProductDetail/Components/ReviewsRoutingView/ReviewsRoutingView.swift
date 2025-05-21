//
//  ReviewsRoutingView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 30.04.2025.
//

import UIKit
import SnapKit

final class ReviewsRoutingView: UIView {

    private var stack: ReviewsRoutingStack?

    var tapPerformed: Completion?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configureView(with rating: Double) {
        stack?.configureStarRating(with: rating)
    }
}


// MARK: - Setup UI
private extension ReviewsRoutingView {

    func setupView() {
        guard let viewFromNib = ReviewsRoutingStack.loadFromNib() else { return }
        self.stack = viewFromNib
        addSubview(viewFromNib)
        setupConstraints(of: viewFromNib)
        setTapGesture()
    }

    func setupConstraints(of subview: UIView) {
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        stack?.addGestureRecognizer(tapGesture)
    }


    @objc func handleTap() {
        tapPerformed?()
    }
}
