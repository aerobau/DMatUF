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

                for eventDict in result {
                    
                    if let id = (eventDict["id"] as AnyObject?)?.integerValue {
                        if let event = self.fetchEvent(id) {
                            self.updateEvent(eventDict, id: id)
                        } else {
                            self.createEvent(eventDict)
                        }
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