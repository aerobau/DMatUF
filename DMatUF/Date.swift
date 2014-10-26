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
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        if let date = formatter.dateFromString(dateString) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            self.init(timeIntervalSince1970: 0)
        }
        NSDate.formattedString(startDate: NSDate(), endDate: NSDate())
    }
    
    class func formattedString(startDate start: NSDate, endDate end: NSDate) -> String {
        let startFormat = NSDateFormatter()
        startFormat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        var s = ""
        
        
        return s
    }
}