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

extension EventViewController {
    
    func fetchJSON(sender: AnyObject?) {
        
        let session = NSURLSession.sharedSession()
        let url: NSURL! = NSURL(string: "http://store.floridadm.org/app/events.php")
        
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
                self.update()
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl?.endRefreshing()
                    return
                }
            }
        }.resume()
    }
}