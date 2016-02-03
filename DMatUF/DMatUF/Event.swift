//
//  Event.swift
//  DM
//
//  Created by Ian MacCallum on 10/23/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class Event: NSManagedObject {

    @NSManaged var id: CKRecordID
    @NSManaged var title: String
    @NSManaged var startDate: NSDate
    @NSManaged var endDate: NSDate
    @NSManaged var moreInfo: String
    @NSManaged var location: String
    @NSManaged var imageName: String
    @NSManaged var category: Category
}
