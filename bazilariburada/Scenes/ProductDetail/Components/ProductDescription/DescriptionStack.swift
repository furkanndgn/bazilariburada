//
//  DescriptionStack.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.04.2025.
//

import UIKit

final class DescriptionStack: UIStackView, NibLoadable {

    @IBOutlet weak var headerStack: CollapsableHeaderStack!
    @IBOutlet weak var descriptionLabel: UILabel!

    private var isExpanded = false

    override func awakeFromNib() {
        setupHeaderInteraction()
    }
}

private extension DescriptionStack {

    func setupHeaderInteraction() {
        headerStack.onTap = { [weak self] in
            guard let self = self else { return }
            self.isExpanded.toggle()
            UIView.animate(withDuration: 0.3) {
                self.headerStack.rotateIndicator(according: self.isExpanded)
                self.descriptionLabel.isHidden = !self.isExpanded
                self.superview?.layoutIfNeeded()
            }
        }
    }
}
