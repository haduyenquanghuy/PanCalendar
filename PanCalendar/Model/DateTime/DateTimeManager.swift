//
//  DateTimeManager.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 01/05/2022.
//

import Foundation

struct DateTimeManager {
    
    let currentDate: Date
    
    let calendar = NSCalendar.current
    
    var currentMonthText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    var dates: [DateTimeModel] {
        let startOfMonth = currentDate.startOfMonth()
        let endOfMonth = currentDate.endOfMonth()
        
        var dateTimeModels = datesRange(from: startOfMonth, to: endOfMonth)
        
        var tempDate = startOfMonth

        while !isSunday(date: tempDate) {
            tempDate = Calendar.current.date(byAdding: .day, value: -1, to: tempDate)!
            dateTimeModels.insert(DateTimeModel(currentDate: tempDate), at: 0)
        }

        tempDate = endOfMonth

        while !isSaturday(date: tempDate) {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            dateTimeModels.append(DateTimeModel(currentDate: tempDate))
        }
        
        return dateTimeModels
        
    }
    
    var dateTimeModel: DateTimeModel {
        return DateTimeModel(currentDate: currentDate)
    }
    
    func datesRange(from: Date, to: Date) -> [DateTimeModel] {
        
        var tempDate = from
        var dateTimeModels = [DateTimeModel]()

        while tempDate <= to {
            dateTimeModels.append(DateTimeModel(currentDate: tempDate))
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        }
        
        return dateTimeModels
    }
    
    func isSunday(date: Date) -> Bool{
        let component = calendar.dateComponents([.weekday], from: date)
        return component.weekday! == 1
    }
    
    func isSaturday(date: Date) -> Bool{
        let component = calendar.dateComponents([.weekday], from: date)
        return component.weekday! == 7
    }
    
    func isSameMonth(with date: DateTimeModel) -> Bool{
        return calendar.isDate(date.currentDate, equalTo: currentDate, toGranularity: .month)
    }
    
    func getNextMonth() -> DateTimeManager {
        return DateTimeManager(currentDate: currentDate.nextMonth())
    }
    
    func getPreviousMonth() -> DateTimeManager {
        return DateTimeManager(currentDate: currentDate.previousMonth())
    }
}
