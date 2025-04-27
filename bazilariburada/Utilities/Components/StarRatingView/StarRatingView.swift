//
//  StarRatingView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 26.04.2025.
//

import UIKit
import SnapKit

final class StarRatingView: UIView {

    private let fullStarImage = SFSymbol.starFill.image(with: .Colors.orange100)
    private let halfStarImage = SFSymbol.halfStarFill.image(with: .Colors.orange100)
    private let emptyStarImage = SFSymbol.star.image(with: .Colors.orange100)

    private var starsStack: StarsStack?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureView(with: 3.5)
    }

    func configureView(with rating: Double) {
        let starImageViews = [
            starsStack?.starImage1,
            starsStack?.starImage2,
            starsStack?.starImage3,
            starsStack?.starImage4,
            starsStack?.starImage5
        ]

        for i in 0...4 {
            starImageViews[i]?.image = getStarImage(for: rating, index: i)
        }
    }
}

private extension StarRatingView {
    func setupView() {
        guard let viewFromNib = StarsStack.loadFromNib() else { return }
        self.starsStack = viewFromNib
        addSubview(viewFromNib)
        setupConstraints(of: viewFromNib)
    }

    func setupConstraints(of subView: UIView) {
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func getStarImage(for rating: Double, index: Int) -> UIImage? {
        let fullThreshold = Double(index) + 0.75
        let halfThreshold = Double(index) + 0.25

        if rating >= fullThreshold {
            return fullStarImage
        } else if rating >= halfThreshold {
            return halfStarImage
        } else {
            return emptyStarImage
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let view = StarRatingView()
    view.configureView(with: 3.5)
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    return view
}
