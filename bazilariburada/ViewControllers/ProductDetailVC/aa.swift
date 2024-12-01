//
//  11.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 1.12.2024.
//

import UIKit

@IBDesignable
class Label: UILabel {
    
    @IBInspectable
    var tc: UIColor {
        get { return self.textColor }
        set { textColor = newValue}
    }
    
    
}
