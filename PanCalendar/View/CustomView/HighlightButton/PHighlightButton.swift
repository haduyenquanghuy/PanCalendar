//
//  PHighlightButton.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 08/05/2022.
//

import Foundation
import UIKit

class PHighlightButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.75 : 1.0
        }
    }
}
