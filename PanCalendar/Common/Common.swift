//
//  Common.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 02/05/2022.
//

import Foundation

enum PDateFormat: String {
    case longFormat =  "MMM d yyyy, HH:mm"
}

struct Constant {
    static let extraSpaceToScroll = 80.0
}

struct Common {
    static func convertDate(_ date: Date, with format: PDateFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: date)
    }
    
    static func convertDate(_ dateStr: String, with format: PDateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateStr)
        
        return date
    }
}
