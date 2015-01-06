//
//  Announcement.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Announcement: NSManagedObject {

    @NSManaged var text: String?
    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber

}
