//
//  CAFunctions.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/6/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class CAF {
    
    class func openURL(dict: [String]) {
        let application: UIApplication = UIApplication.sharedApplication()
        for url in dict {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
    
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


}