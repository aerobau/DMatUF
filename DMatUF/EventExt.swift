//
//  EventCat.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/17/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//
import Foundation
extension Event {

    func updateFromDictionary(eventDictionary: [String: AnyObject?]) {
        for (key, value) in eventDictionary {
          
            // Check and update the corresponding property for key
            switch key{
            case "id":
                if let i: NSNumber = eventDictionary["id"] as? NSNumber{
                    if self.id.integerValue != i.integerValue{
                        self.id = i
                    }
                    break
                }
            case "title":
                if let t: NSString = eventDictionary["title"] as? NSString{
                    self.title = t
                    break
                }
            case "lastUpdated":
                if let d: NSDate = eventDictionary["lastUpdated"] as? NSDate{
                    self.lastUpdated = d
                    break
                }
                
            default:
                break
            }
        }
    }
}
