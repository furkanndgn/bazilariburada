//
//  CollapsableHeaderStack.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import UIKit

final class CollapsableHeaderStack: UIStackView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateIndicator: UIImageView!

    var onTap: (() -> Void)?

    @objc func didTapHeader() {
        onTap?()
    }

    func rotateIndicator(according expanded: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.stateIndicator.transform = expanded ?
            CGAffineTransform(rotationAngle: .pi / 2) : .identity
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension CollapsableHeaderStack {
    func setupView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
}
