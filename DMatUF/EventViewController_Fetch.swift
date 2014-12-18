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
    
    
    func fetchJSON(sender: AnyObject) {
        
        refreshControl?.beginRefreshing()
        
        let session = NSURLSession.sharedSession()
        let url: NSURL! = NSURL(string: "http://104.236.1.77/app/events.php")
        
        session.dataTaskWithURL(url) { (data, response, error)  in
            
            var jsonError: NSError?
            var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: &jsonError)
            println(rawJSON)

            if jsonError == nil {
                
                if let result = rawJSON as? [[String: AnyObject]] {
                    
                    for eventDict in result {
                        
                        if let id: AnyObject = eventDict["id"] {
                            let i = id.integerValue
                            if let event: Event = self.fetchEvent(i) {
                                self.updateEvent(eventDict, id: i)
                            } else {
                                self.createEvent(eventDict)
                            }
                        }
                    }
                    self.update()
                }
            }
            self.refreshControl?.endRefreshing()
        }.resume()
    }
}