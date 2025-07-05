//
//  LoadingView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 19.06.2025.
//

import UIKit
import SnapKit

final class LoadingView: UIView {

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { return nil }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}


// MARK: - Setup UI
private extension LoadingView {
    func setupView() {
        backgroundColor = .systemBackground
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        setupConstraints()
    }
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

