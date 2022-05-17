//
//  PExitTableCell.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 15/05/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        
        return lastIndexPath == indexPath
    }
}
