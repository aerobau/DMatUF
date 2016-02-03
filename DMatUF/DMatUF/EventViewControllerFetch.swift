//
//  EventViewController_Fetch.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit

extension EventViewController {
    func fetchFromICloud() {
        let query = CKQuery(recordType: "Event", predicate: NSPredicate(value: true))
        
        publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            print(error?.localizedDescription)
            var ids : [CKRecordID] = []
            for record in results! {
                ids.append(record.recordID)
                if let _ = self.fetchEvent(record.recordID) {
                    self.updateEvent(record)
                } else {
                    self.createEvent(record)
                }
            }
            for event in self.fetchedResultsController.fetchedObjects as! [Event] {
                guard let id = event.id else { continue }
                if ids.indexOf(id) == nil {
                    self.deleteEvent(id)
                }
            }
            self.update()
        }
    }
    
    /*
    func fetchJSON(sender: AnyObject?) {

        let session = NSURLSession.sharedSession()
        let url: NSURL! = NSURL(string: "http://dev.floridadm.org/app/events.php")
        
        session.dataTaskWithURL(url) { (data, response, error)  in
            guard let data = data else { return }
            
//            let rawJSON = try? NSJSONSerialization.JSONObjectWithData(data!, options: .allZeros)
            let rawJSON = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
            
            if let result = rawJSON as? [[String: AnyObject]] {

                var ids: [Int] = []
                
                for eventDict in result {

                    if let id = (eventDict["id"] as AnyObject?)?.integerValue {
                        ids.append(id)
                        
                        if let _ = self.fetchEvent(id) {
                            self.updateEvent(eventDict, id: id)
                        } else {
                            self.createEvent(eventDict)
                        }
                    }
                }
                for event in self.fetchedResultsController.fetchedObjects as! [Event] {
                    if ids.indexOf(event.id.integerValue) == nil {
                        self.deleteEvent(event.id.integerValue)
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
    */
}