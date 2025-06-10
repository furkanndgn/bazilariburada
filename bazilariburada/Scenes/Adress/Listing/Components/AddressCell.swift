//
//  AddressCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import UIKit

final class AddressCell: BaseTableViewCell, NibLoadable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectedIndicatorImage: UIImageView!

    var editTapped: Completion?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with address: Address) {
        nameLabel.text = address.addressName
        addressLabel.text = address.fullStreetAddress
        selectedIndicatorImage.isHidden = !address.isSelected
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        editTapped?()
    }
}
