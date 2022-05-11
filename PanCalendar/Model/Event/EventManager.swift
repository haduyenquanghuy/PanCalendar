//
//  EventManager.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 10/05/2022.
//

import Foundation
import UIKit
import CoreData

struct EventManager {

    static let shared = EventManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
    
    let managedContext: NSManagedObjectContext
    
    private init(){
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func loadEvents() -> [Event]{
        
        var result = [Event]()
        
        do {
            result = try managedContext.fetch(fetchRequest) as! [Event]
            for event in result {
                print(event.startTime!)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return result
        }
        return result
    }

    func loadEvents(by date: Date) -> [Event] {
        
        var result = [Event]()
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        
        let sameDatePredicate = NSPredicate(format: "startTime < %@ AND endTime >= %@ ", dateTo as NSDate,  dateFrom as NSDate)
        
        fetchRequest.predicate = sameDatePredicate
        
        do {
            result =  try managedContext.fetch(fetchRequest) as! [Event]
            return result
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    func getManagerContext() -> NSManagedObjectContext {
        
        return managedContext
    }
    
    @discardableResult func save() -> Bool {
        do {
            try managedContext.save()
            
        } catch {
            print("Could not save event!. \(error), \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func deleteAllEvents() {
        let events = loadEvents()
        for event in events {
            managedContext.delete(event)
        }
        save()
    }
    
    func delete(_ event: Event){
        managedContext.delete(event)
        save()
    }
    
}
