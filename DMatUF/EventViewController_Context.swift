//
//  Context.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import CoreData

extension EventViewController {
    var appDelegate: AppDelegate? {
        get {
            return UIApplication.sharedApplication().delegate as? AppDelegate
        }
    }
    
    var managedObjectContext: NSManagedObjectContext? {
        get {
            if let delegate = appDelegate {
                return delegate.managedObjectContext
            }
            return nil
        }
    }
    
    
        
}