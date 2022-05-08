//
//  PHideCursorBottomBorderTextField.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 08/05/2022.
//

import Foundation
import UIKit

class PHideCursorBottomBorderTextField: PBottomBorderLabel {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}
