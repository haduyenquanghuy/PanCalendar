//
//  CalendarCollectionViewCell.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 30/04/2022.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    
    static let identifier = "CalendarCollectionViewCell"
    
    public func configure(with text: String) {
        self.contentLabel.text = text
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

