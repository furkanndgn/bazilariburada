//
//  ProductDescriptionSection.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 24.04.2025.
//

import UIKit
import SnapKit

@IBDesignable
final class ProductDescriptionSection: UIView {

    private var expandableView: ExpandableView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configureView(with content: String) {
        expandableView?.configureView(
            title: "Product Detail",
            indicatorImage: UIImage(systemName: "chevron.right"),
            content: content
        )
        expandableView?.setupHeightConstraint(60)
    }
}

private extension ProductDescriptionSection {

    func setupView() {
        guard let viewFromNib = ExpandableView.loadFromNib() else { return }
        self.expandableView = viewFromNib
        addSubview(viewFromNib)
        setupConstraints(of: viewFromNib)
    }

    func setupConstraints(of subView: UIView) {
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
