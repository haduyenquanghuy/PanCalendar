//
//  PBottomBorderLabel.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 08/05/2022.
//

import Foundation
import UIKit

class PBottomBorderLabel: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorderWithColor(color: .separator, width: 1)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
}
