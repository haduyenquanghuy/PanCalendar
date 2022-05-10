//
//  DateTimeModel.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 01/05/2022.
//

import Foundation

struct DateTimeModel {
    let currentDate: Date
    
    var shortDateLabel: String {
        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "dd"
        return shortFormatter.string(from: currentDate)
    }
    
    var longDateLabel: String {
        let longFormatter = DateFormatter()
        longFormatter.dateFormat = "MMM d, yyyy"
        return longFormatter.string(from: currentDate)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(currentDate)
    }
    
    func isSame(_ date: Date?) -> Bool {
        if let date = date {
            return Calendar.current.isDate(currentDate, inSameDayAs: date)
        }
        return false
    }
}
