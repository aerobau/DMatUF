//
//  Category.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/31/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var events: NSSet

}
