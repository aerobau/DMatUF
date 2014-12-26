//
//  Date.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation




extension NSDate {
    convenience init(fromString dateString: String) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.timeZone = NSTimeZone.systemTimeZone()
        let formattedDate = formatter.dateFromString("\(dateString) GMT")

        if let date = formattedDate?.dateByAddingHours(4) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            println("Unable to format date from '\(dateString)'")
            self.init(timeIntervalSince1970: 0)
        }
    }
    
    class func relativeDateString(#start: NSDate?, end: NSDate?) -> String {
        
        var time: String?
        
        if let startTemp = start {
            time = startTemp.toString(format: .Custom("h:mm a"))
            
            if let endTemp = end {
                time = (time ?? "") + " to "
                time = (time ?? "") + endTemp.toString(format: .Custom("h:mm a"))
                
                if startTemp.day() != endTemp.day() {
                    time = (time ?? "") + " on "
                    time = (time ?? "") + endTemp.toString(format: .Custom("M/dd"))
                }
            }
        }

        return time ?? ""
    }
}


extension NSDateFormatter {
    func adjustedString(fromDate date: NSDate) -> String {
        return ""
    }
}