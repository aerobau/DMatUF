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
//    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        
        view.backgroundColor = Color.tvcEven
        titleLabel.textColor = Color.primary2
    }
    
    func setInfo(){
        titleLabel.text = event?.eTitle ?? ""
        locationLabel.text = event?.eLocation ?? ""
//        dateLabel.text = NSDate.relativeDateString(start: event?.eStart, end: event?.eEnd) ?? ""
        descriptionTextView.text = event?.eDescription ?? ""
        
        
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
        
        event.title = self.event?.eTitle
        event.location = self.event?.eLocation
        event.calendar = store.defaultCalendarForNewEvents
        event.startDate = self.event?.eStart
        event.endDate = self.event?.eEnd
        event.notes = self.event?.eDescription
        
        addEventController.event = event
        
        store.requestAccessToEntityType(EKEntityType(), completion: {granted, error in
            self.presentViewController(addEventController, animated: true, completion: nil)
        })
        
    }
}