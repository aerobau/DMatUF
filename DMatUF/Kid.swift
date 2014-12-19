//
//  Kid.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/18/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class Kid {
    var name: String?
    var age: NSDate?
    var story: String?
    var imageName: String?
    
    convenience init(dict: Dictionary<String, AnyObject>) {
        self.init()
        name = Optional(dict["name"]! as? String)!
        age = Optional(dict["age"]! as? NSDate)!
        story = Optional(dict["story"]! as? String)!
        imageName = Optional(dict["image"]! as? String)!
    }
}
