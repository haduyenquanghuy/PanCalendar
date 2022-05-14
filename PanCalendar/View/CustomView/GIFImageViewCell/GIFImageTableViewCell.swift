//
//  GIFImageTableViewCell.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 12/05/2022.
//

import UIKit
import Gifu

class GIFImageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gifImageView.prepareForAnimation(withGIFNamed: "no-data")
    }

    @IBOutlet weak var gifImageView: GIFImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
