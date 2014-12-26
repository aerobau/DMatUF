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
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: "eSecID", cacheName: nil)
        return fetchedResultsController
    }
    
    func eventsFetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let sortDescriptor = NSSortDescriptor(key: "eSecID", ascending: false)
        let sortDescriptor1 = NSSortDescriptor(key: "eStart", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "eEnd", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor1, sortDescriptor2]
        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000
        return fetchRequest
    }

    func fetchEvent(eventID: Int) -> Event? {
        
        // Define fetch request/predicate
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let predicate = NSPredicate(format: "eID == \(eventID)")
        
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
}