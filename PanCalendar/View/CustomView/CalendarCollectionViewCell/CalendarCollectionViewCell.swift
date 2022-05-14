//
//  CalendarCollectionViewCell.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 30/04/2022.
//

import UIKit

enum PCellType {
    case weekday
    case date
    case disabled
    case chosen
    case today
}

class CalendarCollectionViewCell: UICollectionViewCell {
    
    var type : PCellType = .date {
        didSet {
            refreshUI()
            switch type {
            case .weekday:
                contentLabel.font = UIFont(name: "Gill Sans-Light", size: 18.0)
                contentLabel.textColor = UIColor(rgb: 0x8C8F93)
            case .date:
                break
            case .disabled:
                isUserInteractionEnabled = false
                contentLabel.alpha = 0.25
            case .chosen, .today:
                contentView.layer.cornerRadius = frame.width / 2
                contentLabel.textColor = .white
                if type == .chosen {
                    contentView.backgroundColor = UIColor(rgb: 0xFF8552)
                } else {
                    contentView.backgroundColor = UIColor(rgb: 0x205375)
                }
            }
        }
    }
    
    func refreshUI() {
        contentView.layer.cornerRadius = 0
        contentView.backgroundColor = .clear
        isUserInteractionEnabled = true
        contentLabel.font = UIFont(name: "Gill Sans", size: 18.0)
        contentLabel.textColor = UIColor(rgb: 0x39393A)
        contentLabel.alpha = 1.0
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    
    static let identifier = "CalendarCollectionViewCell"
    
    public func configure(with text: String) {
        contentLabel.text = text
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

