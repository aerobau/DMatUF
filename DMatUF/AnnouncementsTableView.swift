//
//  AnnouncementsTableView.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AnnouncementsTableView: UITableView, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()
    let refreshControl = UIRefreshControl()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        estimatedRowHeight = 40.0

        fetchedResultsController = NSFetchedResultsController(fetchRequest: allAnnouncementsFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        dataSource = self
        delegate = self
        fetchedResultsController.performFetch(nil)
        
        refreshControl.addTarget(self, action: "fetchJSON:", forControlEvents: UIControlEvents.ValueChanged)
        addSubview(refreshControl)
        
        fetchJSON(nil)

        
    
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CAF.version < 8.0 ? 40.0 : UITableViewAutomaticDimension
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as AnnouncementCell
        let cellAnnouncement = fetchedResultsController.objectAtIndexPath(indexPath) as Announcement
        
        cell.titleLabel.text = cellAnnouncement.text
        cell.dateLabel.text = cellAnnouncement.date.toString(format: DateFormat.Custom("MM/dd/yy 'at' h:mm a"))
        return cell
    }
}

extension AnnouncementsTableView {
    func fetchJSON(sender: AnyObject?) {
        
        let session = NSURLSession.sharedSession()
        let url: NSURL! = NSURL(string: "http://store.floridadm.org/app/announcements.php")
        
        session.dataTaskWithURL(url) { (data, response, error)  in
            
            var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil)
            
            
            if let result = rawJSON as? [[String: AnyObject]] {
                println(result)
                for eventDict in result {
                        
                    if let id = (eventDict["id"] as AnyObject?)?.integerValue {

                        if let event = self.fetchAnnouncement(id) {
                            self.updateAnnouncement(eventDict, id: id)
                        } else {
                            self.createAnnouncement(eventDict)
                        }
                    }
                }
                self.update()
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl.endRefreshing()
                    return
                }
            }
        }.resume()
    }
}


// MARK: CRUD
extension AnnouncementsTableView {


    // Create
    func createAnnouncement(eventDict: Dictionary<String, AnyObject>) {
        
        var newAnnouncement = NSEntityDescription.insertNewObjectForEntityForName("Announcement", inManagedObjectContext: self.managedObjectContext!) as Announcement
        
        newAnnouncement.id = getInt(eventDict["id"])
        newAnnouncement.text = getString(eventDict["text"])
        newAnnouncement.date = getDate(eventDict["date"])
    }
    
    // Read
    func allAnnouncementsFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Announcement")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000
        return fetchRequest
    }
    
    func fetchAnnouncement(id: Int) -> Announcement? {
        
        // Define fetch request/predicate
        var fetchRequest = NSFetchRequest(entityName: "Announcement")
        let predicate = NSPredicate(format: "id == \(id)")
        
        // Assign fetch request properties
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        
        // Handle results
        let fetchedResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchedResults?.count != 0 {
            
            if let fetchedAnnouncement = fetchedResults![0] as? Announcement {
                return fetchedAnnouncement
            }
        }
        return nil
    }
    
    // Update
    func updateAnnouncement(eventDict: Dictionary<String, AnyObject>, id: Int) {
        if let announcement = fetchAnnouncement(id) {
            announcement.text = getString(eventDict["text"])
            announcement.date = getDate(eventDict["date"])
        }
    }
    
    func update() {
        
        if self.managedObjectContext!.hasChanges {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                
                self.managedObjectContext?.save(nil)
                self.fetchedResultsController.performFetch(nil)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
                return
            }
        }
    }
}

extension AnnouncementsTableView {

    func getInt(obj: AnyObject?) -> Int {
        return obj?.integerValue ?? 0
    }
    
    func getString(obj: AnyObject?) -> String {
        return obj as? String ?? ""
    }
    
    func getDate(obj: AnyObject?) -> NSDate {
        return NSDate(fromString: obj as String) ?? NSDate(timeIntervalSince1970: 0)
    }
}