//
//  OrderCell.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.06.2025.
//

import UIKit

class OrderCell: BaseTableViewCell, NibLoadable {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func configure(with order: Order) {
        dateLabel.text = order.date.orderDate()?.formatted(date: .complete, time: .omitted)
        addressLabel.text = order.address
    }
}
