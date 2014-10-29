//
//  EventViewController_Format.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/28/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//


import UIKit
import CoreData

extension EventViewController {
    func formatDateForCell(start: NSDate?, end: NSDate?) -> String {
        if let s = start {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy 'at' h:mm a zzz"
            let startString = formatter.stringFromDate(s)
            
            return startString
        }
        return ""
    }
}