//
//  Event.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/14/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {
    var name = "Event"
    @NSManaged var id: NSNumber
    @NSManaged var complete: NSNumber
    @NSManaged var stopDate: NSDate
    @NSManaged var startDate: NSDate
    @NSManaged var title: String

}
