//
//  EventTableViewCell.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 06/05/2022.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 8.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
