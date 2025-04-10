//
//  StarRatingView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 2.12.2024.
//

import UIKit
import SnapKit

public enum StarRounding: Int {
    case roundToHalfStar = 0
    case ceilToHalfStar = 1
    case floorToHalfStar = 2
    case roundToFullStar = 3
    case ceilToFullStar = 4
    case floorToFullStar = 5
}

@IBDesignable
final class StarRatingView: UIView {
    
    private var horizontalStack: StarRatingStackView?
    var onTap: (() -> Void)?
    private let fullStarImage = UIImage(systemName: "star.fill")
    private let halfStarImage = UIImage(systemName: "star.leadinghalf.filled")
    private let emptyStarImage = UIImage(systemName: "star")
    
    @IBInspectable var rating: Float = 3.5 {
        didSet {
            updateStarsForRating(rating)
        }
    }
    
    @IBInspectable var starColor: UIColor = .systemOrange {
        didSet {
            updateStarColor()
        }
    }
    
    @IBInspectable var starRoundingRawValue: Int {
        get {
            starRounding.rawValue
        }
        set {
            starRounding = StarRounding(rawValue: newValue) ?? .roundToHalfStar
        }
    }
    
    @IBInspectable var viewIsUserInteractable: Bool {
        get {
            self.isUserInteractionEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
        }
    }
    
    var starRounding: StarRounding = .roundToHalfStar {
        didSet {
            updateStarsForRating(rating)
        }
    }
    
    convenience init(frame: CGRect, starColor: UIColor, starRounding: StarRounding) {
        self.init(frame: frame)
        setupView(rating: rating, starColor: starColor, starRounding: starRounding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: self.rating, starColor: self.starColor, starRounding: self.starRounding)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(rating: 3.5, starColor: .systemOrange, starRounding: .roundToHalfStar)
    }
    
    private func setupView(rating: Float, starColor: UIColor, starRounding: StarRounding) {
        guard let horizontalStack = StarRatingStackView.loadFromNib() else { return }
        addSubview(horizontalStack)
        setupConstraints(of: horizontalStack)
        updateView(rating: rating, starColor: starColor, starRounding: starRounding)
        setupGestures()
    }
    
    private func setupConstraints(of subview: UIView) {
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateView(rating: Float, starColor: UIColor, starRounding: StarRounding) {
        self.rating = rating
        self.starColor = starColor
        self.starRounding = starRounding
        self.isMultipleTouchEnabled = false
        self.isUserInteractionEnabled = true
        self.horizontalStack?.isUserInteractionEnabled = false
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
        
    private func updateStarColor()  {
        guard let horizontalStack = self.horizontalStack else { return }
        let starImageViews = [
            horizontalStack.star1ImageView,
            horizontalStack.star2ImageView,
            horizontalStack.star3ImageView,
            horizontalStack.star4ImageView,
            horizontalStack.star5ImageView
        ]
        for starImageView in starImageViews {
            starImageView?.tintColor = starColor
        }
    }
    
    private func updateStarsForRating(_ rating: Float) {
        guard let horizontalStack = self.horizontalStack else { return }
        let starImageViews = [
            horizontalStack.star1ImageView,
            horizontalStack.star2ImageView,
            horizontalStack.star3ImageView,
            horizontalStack.star4ImageView,
            horizontalStack.star5ImageView
        ]
        for i in 1...5 {
            let starImage = getStarImage(for: rating, index: Float(i))
            starImageViews[i - 1]?.image = starImage
        }
    }
    
    private func getStarImage(for rating: Float, index: Float) -> UIImage? {
        let starImage: UIImage?
        switch starRounding {
        case .roundToHalfStar:
            starImage = getImageForHalfStarRounding(rating: rating, index: index)
        case .ceilToHalfStar:
            starImage = getImageForCeilHalfStarRounding(rating: rating, index: index)
        case .floorToHalfStar:
            starImage = getImageForFloorHalfStarRounding(rating: rating, index: index)
        case .roundToFullStar:
            starImage = rating >= index - 0.5 ? fullStarImage : emptyStarImage
        case .ceilToFullStar:
            starImage = rating > index - 1 ? fullStarImage : emptyStarImage
        case .floorToFullStar:
            starImage = rating >= index ? fullStarImage : emptyStarImage
        }
        return starImage
    }
    
    private func getImageForHalfStarRounding(rating: Float, index: Float) -> UIImage? {
        let image = rating >= index - 0.25 ? fullStarImage :
        (rating >= index - 0.75 ? halfStarImage : emptyStarImage)
        return image
    }
    
    private func getImageForCeilHalfStarRounding(rating: Float, index: Float) -> UIImage? {
        let image = rating > index - 0.5 ? fullStarImage :
        (rating > index - 1 ? halfStarImage : emptyStarImage)
        return image
    }
    
    private func getImageForFloorHalfStarRounding(rating: Float, index: Float) -> UIImage? {
        let image = rating >= index ? fullStarImage :
        (rating >= index - 0.5 ? halfStarImage : emptyStarImage)
        return image
    }
    
    /// Mark: Action Functions
    @objc
    private func handleTap() {
        onTap?()
    }
    
//
//    var lastTouched: Date?
//    
//    private func touched(touch: UITouch, moveTouch: Bool) {
//        guard !moveTouch || lastTouched == nil || lastTouched!.timeIntervalSinceNow < -0.1 else { return }
//        guard let horizontalStack = self.horizontalStack else { return }
//        let touchX = touch.location(in: horizontalStack).x
//        let ratingFromTouch = Float(5 * touchX / horizontalStack.frame.width)
//        let roundedRatingFromTouch = roundedRating(for: ratingFromTouch)
//        self.rating = roundedRatingFromTouch
//        lastTouched = Date()
//    }
//    
//    private func roundedRating(for rating: Float) -> Float {
//        var result: Float = 0
//        switch starRounding {
//        case .roundToHalfStar, .ceilToHalfStar, .floorToHalfStar:
//            result = round(2 * rating) / 2
//        case .roundToFullStar, .ceilToFullStar, .floorToFullStar:
//            result = round(rating)
//        }
//        
//        return result
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        touched(touch: touch, moveTouch: false)
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        touched(touch: touch, moveTouch: true)
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        touched(touch: touch, moveTouch: false)
//    }
}
