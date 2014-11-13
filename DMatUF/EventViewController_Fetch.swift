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
        let url: NSURL! = NSURL(string: "http://mickmaccallum.com/ian/events.php")
        
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
                                println("ID = \(i) needs Update")
                                self.updateEvent(eventDict, id: i)
                                
                                // let a: NSTimeInterval = event.eMod.timeIntervalSince1970
                                // let b: NSTimeInterval = NSDate(fromString: d).timeIntervalSince1970
                                // if a < b {
                                // println("ID = \(i) needs Update")
                                // self.updateEvent(eventDict, id: i)
                                // } else {
                                // println("ID = \(i) is up to date!")
                                // }
                            } else {
                                println("ID = \(i) needs Creation")
                                self.createEvent(eventDict)
                            }

                            
//                            println(i)
//                            if let d: String = eventDict["lastModified"] as? String {
//                                
//                            }
                        }
                    }
                    self.update()
                }
            }
            self.refreshControl?.endRefreshing()
        }.resume()
    }
}