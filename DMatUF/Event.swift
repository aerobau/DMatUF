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

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var startDate: NSDate
    @NSManaged var endDate: NSDate
    @NSManaged var moreInfo: String
    @NSManaged var location: String
    @NSManaged var imageName: String

//    dynamic var complete: Bool {
//        if startDate.timeIntervalSince1970 > NSDate().timeIntervalSince1970 {
//            return false
//        }
//        return true
//    }
}
