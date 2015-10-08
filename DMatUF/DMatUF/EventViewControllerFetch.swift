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
                    self.refreshControl?.endRefreshing()
                    return
                }
            }
        }.resume()
    }
    
}