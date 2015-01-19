//
//  DataManager.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/8/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()
    var task: NSURLSessionDataTask?
    
    var tableView: UITableView?
    var refreshControl: UIRefreshControl?
    var startLoad: () -> Void = {}
    var endLoad: () -> Void = {}
    
    init(tableView: UITableView?, refreshControl: UIRefreshControl?) {
        self.tableView = tableView
        self.refreshControl = refreshControl
    }
    
    func fetchJSON(completion: () -> Void) {
        let session = NSURLSession.sharedSession()
        let url: NSURL! = NSURL(string: "http://dev.floridadm.org/app/events.php")
        
        session.dataTaskWithURL(url) { (data, response, error)  in
        
        var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil)
        
            if let result = rawJSON as? [[String: AnyObject]] {
                println(result)
                var ids: [Int] = []
                
                for eventDict in result {
                    println(eventDict)
                
                    if let id = (eventDict["id"] as AnyObject?)?.integerValue {
                        ids.append(id)
        
                        if let event = self.fetchEvent(id) {
                            self.updateEvent(eventDict, id: id)
                        } else {
                            self.createEvent(eventDict)
                        }
                    }
                }
                for event in self.fetchedResultsController.fetchedObjects as [Event] {
                    if (find(ids, event.id.integerValue) == nil) {
                        self.deleteEvent(event.id.integerValue)
                        println("Deleted event with id: \(event.id)")
                    }
                }
//                self.update()
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl?.endRefreshing()
                    return
                }
            }
        }.resume()
    }
}


extension DataManager {
    // Create
    func createEvent(eventDict: Dictionary<String, AnyObject>) {
        
        var newEvent: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext!) as Event
        
        newEvent.id = getInt(eventDict["id"])
        newEvent.title = getString(eventDict["title"])
        newEvent.location = getString(eventDict["location"])
        newEvent.moreInfo = getString(eventDict["description"])
        newEvent.startDate = getDate(eventDict["startDate"])
        newEvent.endDate = getDate(eventDict["endDate"])
    }
    
    // Read
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func eventsFetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let predicate = NSPredicate(format: "endDate >= %@", NSDate())
        let sortDescriptor1 = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "endDate", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000
        return fetchRequest
    }
    
    func fetchEvent(eventID: Int) -> Event? {
        
        // Define fetch request/predicate
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let predicate = NSPredicate(format: "id == \(eventID)")
        
        // Assign fetch request properties
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        
        // Handle results
        let fetchedResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchedResults?.count != 0 {
            
            if let fetchedEvent: Event = fetchedResults![0] as? Event {
                return fetchedEvent
            }
        }
        return nil
    }
    
    // Update
    func updateEvent(eventDict: Dictionary<String, AnyObject>, id: Int) {
        if let event: Event = fetchEvent(id) {
            
            event.id = id
            event.title = getString(eventDict["title"])
            event.location = getString(eventDict["location"])
            event.moreInfo = getString(eventDict["description"])
            event.startDate = getDate(eventDict["startDate"])
            event.endDate = getDate(eventDict["endDate"])
        }
    }
    
    func update(#tableView: UITableView, refreshControl: UIRefreshControl?) {
        
        if self.managedObjectContext!.hasChanges {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                
                self.managedObjectContext?.save(nil)
                self.fetchedResultsController.performFetch(nil)
                
                dispatch_async(dispatch_get_main_queue()) {
                    tableView.reloadData()
                    refreshControl?.endRefreshing()
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                refreshControl?.endRefreshing()
                return
            }
        }
    }
    
    // Delete
    func deleteEvent(eventID: Int) {
        if let event = fetchEvent(eventID) {
            managedObjectContext?.deleteObject(event)
        }
    }

}

extension DataManager {
    
    func getSecID(event: Event) -> String {
        return event.startDate.timeIntervalSince1970 < NSDate().timeIntervalSince1970 ? "Completed" : "Upcoming"
    }
    
    func getInt(obj: AnyObject?) -> Int {
        return obj?.integerValue ?? 0
    }
    
    func getString(obj: AnyObject?) -> String {
        return obj as? String ?? ""
    }
    
    func getDate(obj: AnyObject?) -> NSDate {
        return NSDate(fromString: obj as String, format: .FromSQL, timeZone: .EST) ?? NSDate(timeIntervalSince1970: 0)
    }
    
    func dateLabelText(start: NSDate, end: NSDate) -> String {
        var str = start.toString(format: .Custom("h:mm a"), timeZone: .EST)
        
        if start.day() > end.day() {
            return str
        }
        
        if start.day() == end.day() {
            str = str + " - " + end.toString(format: .Custom("h:mm a"), timeZone: .EST)
        } else {
            str = str + " - " + end.toString(format: .Custom("h:mm a 'on' M/dd"), timeZone: .EST)
        }
        
        return str
    }
}
