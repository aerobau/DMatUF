//
//  Kid.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/14/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Kid: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var image: String
    @NSManaged var story: String
    @NSManaged var ageYear: NSNumber
    @NSManaged var milestone: String?

}
