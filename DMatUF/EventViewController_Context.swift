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
    
    
    func update() {
        if self.managedObjectContext!.hasChanges {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                var saveError = NSErrorPointer()
                self.appDelegate?.saveContext()
                
                if saveError == nil {
                    println("Save error = nil")
                }else {
                    println("Save error != nil")
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}