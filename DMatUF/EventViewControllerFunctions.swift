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
        return obj as? String ?? ""
    }
    
    func getDate(obj: AnyObject?) -> NSDate {
        return NSDate(fromString: obj as String, format: .FromSQL, timeZone: .EST) ?? NSDate(timeIntervalSince1970: 0)
    }
    
    func dateLabelText(start: NSDate, end: NSDate) -> String {
        var str = start.toString(format: .Custom("h:mm a"), timeZone: .EST)

        if start.day() > end.day() {
            return str
        }
        
        if (start.hour() == 0 && start.hoursBeforeDate(end) == 24) || (start == end) {
            return "All Day"
        }
        
        if start.day() == end.day() {
            str = str + " - " + end.toString(format: .Custom("h:mm a"), timeZone: .EST)
        } else {
            str = str + " - " + end.toString(format: .Custom("h:mm a 'on' M/dd"), timeZone: .EST)
        }
 
        return str
    }
}