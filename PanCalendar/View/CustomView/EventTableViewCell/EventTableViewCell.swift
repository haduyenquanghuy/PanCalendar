//
//  EventTableViewCell.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 06/05/2022.
//

import UIKit
import CoreData
import ChameleonFramework

protocol EventCellDelegate {
    
    func editItem(at pos: Int)
}

enum EventCellType: String {
    case important = "Important"
    case basic = "Basic"
    case urgent = "Urgent"
}

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var typeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var startDate: PanIconLabel!
    
    @IBOutlet weak var startTime: PanIconLabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var endDate: PanIconLabel!
    
    @IBOutlet weak var endTime: PanIconLabel!
    
    var delegate: EventCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(with event: Event) {
        var color = UIColor.init(hexString: event.color!)
        
        titleLabel.text = event.title!
        
        let typeInfo = event.type!
        
        typeButton.setTitle(typeInfo, for: [])
        
        if typeInfo == EventCellType.basic.rawValue {
            color = color?.lighten(byPercentage: 25/100)
        } else if typeInfo == EventCellType.important.rawValue {
            color = color?.darken(byPercentage: 25/100)
        }
        
        mainView.backgroundColor = color
        typeButton.backgroundColor = color?.inverseColor()
        
        if let desc = event.information {
            descriptionLabel.isHidden = false
            descriptionLabel.text = desc
        } else {
            descriptionLabel.isHidden = true
        }
        
        let startEventTime = event.startTime!
        let endEventTime = event.endTime!
        
        let calendarImage = UIImage(systemName: "calendar")!
        let clockImage = UIImage(systemName: "clock")!
        
        startDate.text = Common.convertDate(startEventTime, with: .dateFormat)
        startTime.text = Common.convertDate(startEventTime, with: .timeFormat)
        
        endDate.text = Common.convertDate(endEventTime, with: .dateFormat)
        endTime.text = Common.convertDate(endEventTime, with: .timeFormat)
        
        startDate.image = calendarImage
        startTime.image = clockImage
        
        endDate.image = calendarImage
        endTime.image = clockImage
    }
    
    @IBAction func pressEdit(_ sender: Any) {
        if let delegate = delegate {
            delegate.editItem(at: tag)
        }
    }
    
    
}
