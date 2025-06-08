//
//  AddressCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import UIKit

final class AddressCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectedIndicatorImage: UIImageView!
    @IBOutlet weak var editButton: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setTapGesture()
    }

    func configure(with address: Address) {
        nameLabel.text = address.name
        addressLabel.text = address.line1
        selectedIndicatorImage.isHidden = !address.isSelected
    }

    private func setTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(editButtonTapped))
        editButton.addGestureRecognizer(gesture)
    }

    @objc func editButtonTapped() {

    }
}
