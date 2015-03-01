//
//  PushNotificationManager.swift
//  DMUF Push Config
//
//  Created by Michael MacCallum on 2/26/15.
//  Copyright (c) 2015 Michael MacCallum. All rights reserved.
//

import CloudKit
#if os(iOS)
import UIKit
#endif

@objc(DMPushNotificationManager) final class PushNotificationManager {
    private let notificationRecordType = "Notifications"

    #if os(iOS)
    private var notificationRecordTypeIdentifier: String? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
        
            return defaults.stringForKey(
                notificationRecordType
            )
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(
                newValue,
                forKey: notificationRecordType
            )
            
            defaults.synchronize()
        }
    }
    #endif

    // MARK: - Abstractification
    private init() { /* Leave empty - Hides initializer from user. */ }
    
    // MARK: - Singleton
    class var sharedInstance: PushNotificationManager {
        struct Static {
            static let instance: PushNotificationManager = PushNotificationManager()
        }
        
        return Static.instance
    }
    
    // MARK: - iOS only
    #if os(iOS)
    // MARK: - UIApplication Lifecycle
    func launchApplication(application: UIApplication) {
        if UIDevice.version >= 8.0 {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
            application.registerForRemoteNotifications()
        }
        
        attemptNotificationSubscription()
    }
    
    // MARK: - Subscription Management
    private func attemptNotificationSubscription() {
        if notificationRecordTypeIdentifier == nil && UIDevice.version >= 8.0 {
            let database = CKContainer.defaultContainer().publicCloudDatabase

        let subscription = CKSubscription(
            recordType: notificationRecordType,
            predicate: NSPredicate(value: true),
            options: CKSubscriptionOptions.FiresOnRecordCreation
        )
        
        let notification = CKNotificationInfo()
        
        notification.alertLocalizationKey = "%1$@"
        notification.alertLocalizationArgs = ["title"]
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.desiredKeys = ["title", "body"]
        notification.shouldBadge = false
        notification.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notification
        
        
            let operation = CKModifySubscriptionsOperation(
                subscriptionsToSave: [subscription],
                subscriptionIDsToDelete: nil //[subscription.subscriptionID]
            )
            
            operation.modifySubscriptionsCompletionBlock = databaseDidModifySubscriptions
            database.addOperation(operation)
        
//        database.fetchAllSubscriptionsWithCompletionHandler({ (subscriptions, error) -> Void in
//            for sub in subscriptions {
//            database.deleteSubscriptionWithID(sub.subscriptionID, completionHandler: { (info, error) -> Void in
//                println(info)
//                })
//            }
//            })

        }
    }
    
    private func databaseDidModifySubscriptions(saved: [AnyObject]!, deleted: [AnyObject]!, error: NSError!) {
        if let first = saved?.first as? CKSubscription {
            notificationRecordTypeIdentifier = first.subscriptionID
        }
    }

    typealias RecordCompletionBlock = (error: NSError!) -> ()
    private var recordCompletionBlock: RecordCompletionBlock?
    
    // MARK: - Record Adding
    func addRecordWithTitle(#title: String, andBody body: String?, completion: RecordCompletionBlock?) {
        recordCompletionBlock = completion
        
        let record = CKRecord(recordType: notificationRecordType)
        
        record.setObject(title, forKey: "title")
        record.setObject(body, forKey: "body")
        
        let saveOperation = CKModifyRecordsOperation(
            recordsToSave: [record],
            recordIDsToDelete: nil
        )
        
        saveOperation.modifyRecordsCompletionBlock = databaseDidModifyRecords
        CKContainer.defaultContainer().publicCloudDatabase.addOperation(saveOperation)
    }
    
    private func databaseDidModifyRecords(saved: [AnyObject]!, deleted: [AnyObject]!, error: NSError!) {
        dispatch_async(dispatch_get_main_queue()) {
            self.recordCompletionBlock?(error: error); return
        }
    }
    
//    func generateNotificationFromPushInfo(userInfo: [NSObject : AnyObject], application: UIApplication) -> Bool {
//        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) {
//            if application.applicationState != UIApplicationState.Active {
//                return true
//            }
//        
//            return false
//        }
//        
//        return false
//    }

    // MARK: - OS X only
    #elseif os(OSX)
    
    #endif
}
