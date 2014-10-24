//
//  DMatUF.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/19/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var lastUpdated: NSDate

}