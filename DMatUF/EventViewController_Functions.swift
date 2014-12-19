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
        return event.eStart.timeIntervalSince1970 < NSDate().timeIntervalSince1970 ? "Completed" : "Upcoming"
    }
    
    func getInt(obj: AnyObject?) -> Int {
        return obj?.integerValue ?? 0
    }
    
    func getString(obj: AnyObject?) -> String {
        return obj as? String ?? ""
    }
    
    func getDate(obj: AnyObject?) -> NSDate {
        return NSDate(fromString: obj as String) ?? NSDate(timeIntervalSince1970: 0)
    }
}