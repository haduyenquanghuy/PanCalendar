//
//  CornerLabel.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 06/05/2022.
//

import UIKit

@IBDesignable class PanCornerButton: UIButton {
    
    @IBInspectable var rounded: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded
        layer.masksToBounds = true
    }
    
}
