//
//  ExpandableView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.04.2025.
//

import UIKit

final class ExpandableView: UIView, NibLoadable {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    private var shouldCollapse = false
    private var heightConstraint: Double = 50

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Bundle.main.loadNibNamed(String(describing: ExpandableView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setTapGesture()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configureView(title: String, indicatorImage: UIImage?, content: String) {
        titleLabel.text = title
        indicatorImageView.image = indicatorImage
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
        mainHeightConstraint.constant = heightConstraint
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2,
            options: [.curveEaseInOut],
            animations: {
                self.layoutIfNeeded()
                self.superview?.layoutIfNeeded()
            },
            completion: nil
        )
        UIView.animate(withDuration: 0.2) {
            self.indicatorImageView.transform = isCollapse ?
            CGAffineTransform(rotationAngle: .pi / 2) : .identity
        }
    }

    func setTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        headerView.addGestureRecognizer(tapRecognizer)
    }
}
