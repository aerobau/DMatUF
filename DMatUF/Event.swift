//
//  Event.swift
//  DM
//
//  Created by Ian MacCallum on 10/23/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var eID: NSNumber
    @NSManaged var eMod: NSDate
    @NSManaged var eTitle: String
    @NSManaged var eStart: NSDate
    @NSManaged var eEnd: NSDate
    @NSManaged var eDescription: String
    @NSManaged var eLocation: String
    @NSManaged var eSecID: String
        
        
        
        
    var sectionIdentifier: String {
        get {
            if eStart.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
                eSecID = "Complete"
                return "Complete"
            }
            eSecID = "Upcoming"
            return "Upcoming"
        }
    }
}
