//
//  EventViewController_Functions.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/18/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation

extension EventViewController {
    
    func getSecID(event: Event) -> String {
        return event.startDate.timeIntervalSince1970 < NSDate().timeIntervalSince1970 ? "Completed" : "Upcoming"
    }
    
    func getInt(obj: AnyObject?) -> Int {
        return obj?.integerValue ?? 0
    }
    
    func getString(obj: AnyObject?) -> String {
        return (obj as? String) ?? ""
    }
    
    func getDate(obj: AnyObject?) -> NSDate {
        return NSDate(fromString: obj as! String, format: .FromSQL, timeZone: .EST) ?? NSDate(timeIntervalSince1970: 0)
    }
    
    func dateLabelText(start: NSDate, end: NSDate) -> String {
        
        // Check in progress
        if start.timeIntervalSince1970 < NSDate().timeIntervalSince1970 && NSDate().timeIntervalSince1970 < end.timeIntervalSince1970 {
            return "In Progress"
        }
        
        if start == end {
            return "All Day"
        }
        

        
        var str = start.toString(format: .Custom("h:mm a"), timeZone: .EST)

        if start.day() > end.day() {
            return str
        } else {
            
            if start.day() == end.day() {
                str = str + " - " + end.toString(format: .Custom("h:mm a"), timeZone: .EST)
            } else {
                str = str + " - " + end.toString(format: .Custom("h:mm a 'on' M/dd"), timeZone: .EST)
            }


//            if start.week() == end.week() {
//                let startDay = start.toString(format: .Custom("EEEE"), timeZone: .EST)
//                let endDay = end.toString(format: .Custom("EEEE"), timeZone: .EST)
//                return "All Day \(startDay) to \(endDay)"
//            } else {
//                let endDate = end.toString(format: .Custom("M'/'d"), timeZone: .EST)
//                
//                return "All Day Ending \(endDate)"
//            }
//
//            
        }
        
        
        return str
    }
}