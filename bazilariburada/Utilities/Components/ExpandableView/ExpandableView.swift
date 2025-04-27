//
//  ExpandableView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.04.2025.
//

import UIKit

final class ExpandableView: UIView, NibLoadable {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stateIndicatorImageView: UIImageView!
    @IBOutlet private weak var bodyView: UIView!
    @IBOutlet private weak var bodyHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentLabel: UILabel!

    private var shouldCollapse = false

    private var heightConstraint: Double = 60

    override func layoutSubviews() {
        super.layoutSubviews()
        setTapRecognizerToHeader()
    }

    func configureView(title: String, indicatorImage: UIImage?, content: String) {
        titleLabel.text = title
        stateIndicatorImageView.image = indicatorImage
        contentLabel.text = content
    }

    func setupHeightConstraint(_ constraint: Double) {
        heightConstraint = constraint
    }

    @objc private func handleTap() {
        if shouldCollapse {
            animateView(isCollapse: false, heightConstraint: 0)
        } else {
            animateView(isCollapse: true, heightConstraint: heightConstraint)
        }
    }
}

private extension ExpandableView {
    func animateView(isCollapse: Bool, heightConstraint: Double) {
        shouldCollapse = isCollapse
        bodyHeightConstraint.constant = CGFloat(heightConstraint)
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                self.layoutIfNeeded()
            },
            completion: nil
        )
        UIView.animate(withDuration: 0.2) {
            self.stateIndicatorImageView.transform = isCollapse ?
            CGAffineTransform(rotationAngle: .pi / 2) : .identity
        }
    }

    func setTapRecognizerToHeader() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        headerView.addGestureRecognizer(tapRecognizer)
    }
}
