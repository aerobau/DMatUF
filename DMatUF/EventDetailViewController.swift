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
    var id: Int! = 0
    var eventTitle: String! = ""
    var startDate: NSDate? = NSDate(timeIntervalSince1970: 0)
    var endDate: NSDate! = NSDate(timeIntervalSince1970: 0)
    var lastModified: NSDate! = NSDate(timeIntervalSince1970: 0)
    var location: String! = ""
    var eventDescription: String! = ""
    
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
    }
    
    func setInfo(){
        idLabel.text = "\(id)"
        titleLabel.text = eventTitle
        
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
        event.title = eventTitle
        event.location = "Turlington"
        event.calendar = store.defaultCalendarForNewEvents
        event.startDate = startDate
        
        if let d = endDate {
            event.endDate = d
        } else {
            event.endDate = self.startDate?.dateByAddingTimeInterval(60*60)
        }
        
        event.notes = eventDescription
        addEventController.event = event
        
        store.requestAccessToEntityType(EKEntityType(), completion: {granted, error in
            self.presentViewController(addEventController, animated: true, completion: nil)
        })
        
    }
}