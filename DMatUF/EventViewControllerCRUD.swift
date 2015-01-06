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
        let predicate = NSPredicate(format: "startDate >= %@", NSDate())
//        let sortDescriptor = NSSortDescriptor(key: "complete", ascending: false)
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
    
    func update() {
        
        if self.managedObjectContext!.hasChanges {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {

                self.managedObjectContext?.save(nil)
                self.fetchedResultsController.performFetch(nil)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl?.endRefreshing()
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