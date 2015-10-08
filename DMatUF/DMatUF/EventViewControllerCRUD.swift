
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

        if getDate(eventDict["endDate"]).timeIntervalSince1970 > NSDate().timeIntervalSince1970 {
            
           let newEvent: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext) as! Event
            let id = getInt(eventDict["id"])
            newEvent.id = id
            newEvent.title = getString(eventDict["title"])
            newEvent.location = getString(eventDict["location"])
            newEvent.moreInfo = getString(eventDict["description"])
            newEvent.startDate = getDate(eventDict["startDate"])
            newEvent.endDate = getDate(eventDict["endDate"])
            newEvent.imageName = getString(eventDict["imageName"])
            newEvent.category = fetchOrCreateCategory(getString(eventDict["category"]))
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.saveImageForEvent(self.getString(eventDict["imageName"]), url: self.getString(eventDict["imageURL"]))
            }
            
        }

    }
    
    func fetchOrCreateCategory(name: String) -> Category {
        if let category = fetchCategory(name) {
            return category
        } else {
            if name != "" {
                let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext) as! Category
                newCategory.name = name
                
                return newCategory
            } else {
                return fetchOrCreateCategory("Other")
            }
        }
    }
    
    func fetchCategory(name: String) -> Category? {
        
        // Define fetch request/predicate
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let predicate = NSPredicate(format: "name = %@", name)
        
        // Assign fetch request properties
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        
        // Handle results
        let fetchedResults = try? managedObjectContext.executeFetchRequest(fetchRequest)
        
        if fetchedResults?.count != 0 {
            
            if let fetchedCategory: Category = fetchedResults![0] as? Category {
                return fetchedCategory
            }
        }
        return nil
    }

    
    func saveImageForEvent(name: String, url: String) {
        
        if name == "" {
            return
        }
        let imagePath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] ).stringByAppendingString("\(name).png")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
            if let eventImage = UIImage(fromURL: url) {
                eventImage.save(name , type: "png")
                print("IMAGE CREATED")
            } else {
                print("IMAGE COULD NOT BE CREATED")
            }
        } else {
            print("IMAGE ALREADY EXISTED")
        }
    }

    // Read
    func getFetchedResultController() -> NSFetchedResultsController {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(nil), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func eventsFetchRequest(category: Category?) -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Event")
        
        if category != nil {
            let predicate = NSPredicate(format: "endDate >= %@ && category = %@", NSDate(), category!)
            fetchRequest.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "endDate >= %@", NSDate())
            fetchRequest.predicate = predicate
        }
        
        let sortDescriptor1 = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "endDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000
        fetchRequest.propertiesToFetch = ["title", "startDate", "endDate", "imageName"]
        return fetchRequest
    }
    
    func fetchCategories() -> [Category] {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let predicate = NSPredicate(format: "events.@count != 0")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000

        return try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Category]
    }

    func fetchEvent(eventID: Int) -> Event? {
        
        // Define fetch request/predicate
        let fetchRequest = NSFetchRequest(entityName: "Event")
        let predicate = NSPredicate(format: "id == \(eventID)")
        
        // Assign fetch request properties
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        
        // Handle results
        let fetchedResults = try? managedObjectContext.executeFetchRequest(fetchRequest)
        
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
            event.imageName = getString(eventDict["imageName"])
            event.category = fetchOrCreateCategory(getString(eventDict["category"]))

            saveImageForEvent(getString(eventDict["imageName"]), url: getString(eventDict["imageURL"]))
        }
    }
    
    func update() {
        
        if self.managedObjectContext.hasChanges {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {

                let _ = try? self.managedObjectContext.save()
                let _ = try? self.fetchedResultsController.performFetch()
                self.deleteOldEvents()
                self.updateCategories()

                dispatch_async(dispatch_get_main_queue()) {
                    self.dropDownTableView.reloadData()
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                    self.dropdownButton.enabled = true
                    self.dropdownButton.userInteractionEnabled = true
                    self.dropdownButton.alpha = 1.0
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl?.endRefreshing()
                return
            }
        }
    }
    
    func updateCategories() {
        dropDownTableView.items = ["All"]
        fetchCategories().forEach {
            self.dropDownTableView.items.append($0.name)
        }
        dropDownTableView.tableView(dropDownTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
    
    // Delete
    func deleteEvent(eventID: Int) {
        if let event = fetchEvent(eventID) {
            managedObjectContext.deleteObject(event)
        }
    }
    
    func deleteOldEvents() {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        
        let predicate = NSPredicate(format: "endDate <= %@", NSDate())
        fetchRequest.predicate = predicate

        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000
        
        if let oldEvents = try? managedObjectContext.executeFetchRequest(fetchRequest) as? [Event] {
            print("OLD EVENTS CALLED")
            for event in oldEvents ?? [] {
                print("OLD EVENT")
                managedObjectContext.deleteObject(event)
            }
            let _ = try? managedObjectContext.save()
        }
    }
}