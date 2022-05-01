//
//  CalendarFooterReusableView.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 02/05/2022.
//

import UIKit

class CalendarFooterReusableView: UICollectionReusableView {
    
    static let identifier = "CalendarFooterReusableView"
    
    public func configure() {
        backgroundColor = UIColor(rgb: 0xE6E6E6)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
