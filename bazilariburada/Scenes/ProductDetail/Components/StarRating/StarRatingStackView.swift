//
//  StarRatingStackView.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 2.12.2024.
//

import UIKit

final class StarRatingStackView: UIStackView, NibLoadable {

    static var nibName = Nib.Name.starRatingStack

    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
