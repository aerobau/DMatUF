//
//  EventViewController_CRUD.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension EventViewController {
    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        println("Content Changed")
        tableView.reloadData()
    }
    
    // Create
    func createEvent(eventDict: Dictionary<String, AnyObject>) {

        var newEvent: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext!) as Event
        
        newEvent.eID = getInt(eventDict["id"])
        newEvent.eTitle = getString(eventDict["title"])
        newEvent.eLocation = getString(eventDict["location"])
        newEvent.eDescription = getString(eventDict["description"])
        newEvent.eStart = getDate(eventDict["startDate"])
        newEvent.eEnd = getDate(eventDict["endDate"])
        newEvent.eMod = NSDate()
        newEvent.eSecID = getSecID(newEvent)
    }
    
    
    
    
    
    // Read
    func getFetchedResultController() -> NSFetchedResultsController {
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: "eSecID", cacheName: nil)
        return fetchedResultController
    }
    
    func eventsFetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let sortDescriptor1 = NSSortDescriptor(key: "eSecID", ascending: false)
        let sortDescriptor = NSSortDescriptor(key: "eID", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.fetchLimit = 1000
        return fetchRequest
    }

    func fetchEvent(eventID: Int) -> Event? {
        
        // Define fetch request/predicate/sort descriptors
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let sortSections = NSSortDescriptor(key: "eTitle", ascending: true)
        let sortDescriptor = NSSortDescriptor(key: "eID", ascending: true)
        let predicate = NSPredicate(format: "eID == \(eventID)", argumentArray: nil)
        var error = NSErrorPointer()
        
        // Assign fetch request properties
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortSections, sortDescriptor]
        fetchRequest.fetchBatchSize = 1
        
        // Handle results
        let fetchedResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: error)
        
        if fetchedResults?.count != 0 {
            
            if let fetchedEvent: Event = fetchedResults![0] as? Event {
                println("Fetched object with ID = \(eventID). The title of this object is '\(fetchedEvent.eTitle)'")
                return fetchedEvent
            }
        }
        return nil
    }
    
    
    
    
    // Update
    func updateEvent(eventDict: Dictionary<String, AnyObject>, id: Int) {
        if let event: Event = fetchEvent(id) {
            println(eventDict)
            
            event.eID = id
            event.eTitle = getString(eventDict["title"])
            event.eLocation = getString(eventDict["location"])
            event.eDescription = getString(eventDict["description"])
            event.eStart = getDate(eventDict["startDate"])
            event.eEnd = getDate(eventDict["endDate"])
            event.eMod = NSDate()
            event.eSecID = getSecID(event)

        }
    }
    
    
    
    
    
    // Delete

    
    
    
    
    
    
    
    
    /* Convert to non-optional */
    func getSecID(event: Event) -> String {
        if event.eStart.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
            return "Completed"
        }
        return "Upcoming"
    }
    
    func getInt(obj: AnyObject?) -> Int {
        if let object = obj?.integerValue {
            return object
        }
        return 0
    }
    
    func getString(obj: AnyObject?) -> String {
        if let object: String = obj as? String {
            println(object)
            return object
        }
        return ""
    }

    func getDate(obj: AnyObject?) -> NSDate {
        if let object: String = obj as? String {
            let date = NSDate(fromString: object)
            return date
        } else {
            return NSDate(timeIntervalSince1970: 0)
        }
    }

}