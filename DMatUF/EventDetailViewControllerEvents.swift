//
//  EventDetailViewControllerEvents.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/22/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI
import CoreData

extension EventDetailViewController: EKEventEditViewDelegate, UIAlertViewDelegate {
    @IBAction func addEventButtonPressed(sender: UIBarButtonItem) {
        
        GA.sendEvent(category: GA.K.CAT.ACTION, action: GA.K.ACT.PRESSED, label: "add event", value: nil)
        
        store.requestAccessToEntityType(EKEntityTypeEvent) { granted, error in
            if granted {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertView(title: "Add all events?", message: "", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Just this event", "Add all events")
                    alert.show()
                }
            }
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            addEventModally(selectedEvent!)
        } else {
            addAllEvents()
        }
    }

    
    
    func addEventModally(event: Event) {
        if eventExists(event) {
            UIAlertView.errorMessage("Event Not Added", message: "This event already exists.")
        } else {
            var addEventController = EKEventEditViewController()
            addEventController.eventStore = store
            addEventController.editViewDelegate = self
            
            var newEvent = EKEvent(eventStore: store)
            newEvent.title = selectedEvent?.title
            newEvent.location = selectedEvent?.location
            newEvent.startDate = selectedEvent?.startDate
            newEvent.endDate = selectedEvent?.endDate
            newEvent.notes = selectedEvent?.moreInfo
            newEvent.calendar = getCalendar()
            addEventController.event = newEvent
                
            self.presentViewController(addEventController, animated: true, completion: nil)
        }
    }
    
    func addAllEvents() {
        var count = 0
        var total = 0
        
        for event in fetchedResultsController?.fetchedObjects! as [Event] {
            total++
            if !eventExists(event) {
                count++
                addEvent(event)
            }
        }
        
        UIAlertView.errorMessage("Events Added", message: "\(count) event(s) created.\n \(total - count) already exist.")
    }
    
    func addEvent(event: Event) {
        println("CREATING NEW EVENT")

        var newEvent = EKEvent(eventStore: self.store)
        newEvent.title = event.title
        newEvent.location = event.location
        newEvent.startDate = event.startDate
        newEvent.endDate = event.endDate
        newEvent.notes = event.moreInfo
        newEvent.calendar = getCalendar()

        self.store.saveEvent(newEvent, span: EKSpanThisEvent, commit: true, error: nil)
    }
    
    func eventExists(event: Event) -> Bool {
        var match = false
        
        let predicate = store.predicateForEventsWithStartDate(event.startDate, endDate: event.endDate, calendars: nil)
        let matchedEvents: Void = store.enumerateEventsMatchingPredicate(predicate) { existingEvent, stop in
            
            if existingEvent.title.lowercaseString == event.title.lowercaseString {
                match = true
                return
            }
        }
        
        if match {
            println("MATCH")
            return true
        } else {
            println("NO MATCH")
            return false
        }
    }

    func eventEditViewController(controller: EKEventEditViewController!, didCompleteWithAction action: EKEventEditViewAction) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getCalendar() -> EKCalendar? {
        let defaults = NSUserDefaults.standardUserDefaults()

        if let id = defaults.stringForKey("calendarID") {
            println(id)
            return store.calendarWithIdentifier(id)
        } else {
            var calendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: self.store)
            
            calendar.title = "Dance Marathon"
            calendar.CGColor = Color.primary1.CGColor
            calendar.source = self.store.defaultCalendarForNewEvents.source
            
            var error: NSError?
            self.store.saveCalendar(calendar, commit: true, error: &error)
            
            if error == nil {
                defaults.setObject(calendar.calendarIdentifier, forKey: "calendarID")
            }
            
            return calendar
        }
    }
}
