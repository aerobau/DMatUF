//
//  GoogleAnalytics.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/3/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class GA: UIAlertView, UIAlertViewDelegate {

    struct K {
        struct CAT {
            static let BUTTON = "UI_Button"
            static let ACTION = "UI_Action"
        }
        
        struct ACT {
            static let PRESSED = "Pressed"
            static let LOADED = "Loaded"
            static let LOGIN = "Login"
        }
    }
    
    class func optOutAlert() {
        func promptOptIn() {
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let newUser = defaults.objectForKey("newUser") as? Bool {
            if newUser {
                promptOptIn()
            }
        } else {
            
        }
        
    }

    class func checkOptOut() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let optOut = defaults.objectForKey("optOut") as? Bool{
            if optOut == true {
                GAI.sharedInstance().optOut = true
            } else {
                GAI.sharedInstance().optOut = false
            }
        } else {
            GAI.sharedInstance().optOut = true
        }
    }
    
    class func initialize(#trackingId: String!, dispatchInterval: NSTimeInterval) {
        GAI.sharedInstance().trackerWithTrackingId(trackingId)
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Info
        GAI.sharedInstance().dispatchInterval = dispatchInterval
        GAI.sharedInstance().dryRun = false
        GAI.sharedInstance().defaultTracker.allowIDFACollection = true
    }
  
    class func sendScreenView(#name: String!) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        tracker.send(GAIDictionaryBuilder.createScreenView().build())
    }
    
    class func sendEvent(#category: String!, action: String!, label: String!, value: NSNumber!) {
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build())
    }

}