//
//  EventDetailViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class EventDetailViewController: UIViewController, EKEventEditViewDelegate {
    var store : EKEventStore = EKEventStore()
    var event: Event?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        
        view.backgroundColor = Color.tvcEven
        
        titleLabel.textColor = Color.primary2
        titleLabel.font = Font.header
        
        dateLabel.textColor = UIColor.blackColor()
        dateLabel.font = Font.body1
        
        locationLabel.textColor = Color.primary1
        locationLabel.font = Font.subheader
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationItem.leftBarButtonItem?.title = "Back"
    }
    
    func setInfo(){
        let startDate = event?.startDate.toString(format: DateFormat.Custom("EEEE, MMMM d 'at' h:mm a"), timeZone: TimeZone.EST) ?? ""
        let endDate = event?.endDate.toString(format: DateFormat.Custom("EEEE, MMMM d 'at' h:mm a"), timeZone: TimeZone.EST)
        
        titleLabel.text = event?.title ?? ""
        dateLabel.text = startDate + (endDate != nil && event?.startDate.timeIntervalSince1970 < event?.endDate.timeIntervalSince1970 ? " -\n" + endDate! : "")
        locationLabel.text = event?.location ?? ""
        descriptionTextView.text = event?.moreInfo ?? ""
    }
    
    
    func eventEditViewController(controller: EKEventEditViewController!, didCompleteWithAction action: EKEventEditViewAction) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func eventEditViewControllerDefaultCalendarForNewEvents(controller: EKEventEditViewController!) -> EKCalendar! {
        return store.defaultCalendarForNewEvents
    }
    
    
    @IBAction func addEvent(sender: UIBarButtonItem) {

        
        
        
        var addEventController = EKEventEditViewController()
        addEventController.eventStore = store
        addEventController.editViewDelegate = self
        
        var event = EKEvent(eventStore: store)
        event.title = self.event?.title
        event.location = self.event?.location
        event.calendar = getCalendar()
        event.startDate = self.event?.startDate
        event.endDate = self.event?.endDate
        event.notes = self.event?.moreInfo
        addEventController.event = event
        
        store.requestAccessToEntityType(EKEntityType(), completion: {granted, error in
            self.presentViewController(addEventController, animated: true, completion: nil)
        })
        
    }
    
    func getCalendar() -> EKCalendar? {
        var calendar: EKCalendar?
        let defaults = NSUserDefaults.standardUserDefaults()
        let calendarID = defaults.stringForKey("calendarID")
        
        if calendarID != nil {
            calendar = store.calendarWithIdentifier(calendarID)
        }
        
        if calendar == nil {
            calendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: store)
            calendar?.title = "Dance Marathon"
            calendar?.CGColor = Color.primary1.CGColor
            calendar?.source = store.defaultCalendarForNewEvents.source

            var error: NSError?
            
            store.saveCalendar(calendar, commit: true, error: &error)
            
            if error == nil {
                defaults.setValue(calendar?.calendarIdentifier, forKey: "calendarID")
            } else {
                println("Unable to save \(error)")
            }
        }
         return calendar
    }
}