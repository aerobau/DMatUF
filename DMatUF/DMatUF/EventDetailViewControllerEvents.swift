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

extension EventDetailViewController: EKEventEditViewDelegate {
    @IBAction func addEventButtonPressed(sender: UIBarButtonItem) {
        
        GA.sendEvent(category: GA.K.CAT.ACTION, action: GA.K.ACT.PRESSED, label: "add event", value: nil)
        
        store.requestAccessToEntityType(.Event) { granted, error in
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
            let addEventController = EKEventEditViewController()
            addEventController.eventStore = store
            addEventController.editViewDelegate = self
            
            let newEvent = EKEvent(eventStore: store)
            newEvent.title = selectedEvent?.title ?? ""
            newEvent.location = selectedEvent?.location
            newEvent.startDate = selectedEvent?.startDate ?? NSDate()
            newEvent.endDate = selectedEvent?.endDate ?? NSDate()
            newEvent.notes = selectedEvent?.moreInfo
            newEvent.calendar = getCalendar() ?? EKCalendar()
            addEventController.event = newEvent
                
            self.presentViewController(addEventController, animated: true, completion: nil)
        }
    }
    
    func addAllEvents() {
        var count = 0
        var total = 0
        
        for event in fetchedResultsController?.fetchedObjects! as! [Event] {
            total++
            if !eventExists(event) {
                count++
                addEvent(event)
            }
        }
        
        UIAlertView.errorMessage("Events Added", message: "\(count) event(s) created.\n \(total - count) already exist.")
    }
    
    func addEvent(event: Event) {
        print("CREATING NEW EVENT")

        let newEvent = EKEvent(eventStore: self.store)
        newEvent.title = event.title
        newEvent.location = event.location
        newEvent.startDate = event.startDate
        newEvent.endDate = event.endDate
        newEvent.notes = event.moreInfo
        newEvent.calendar = getCalendar() ?? EKCalendar()

        let _ = try? self.store.saveEvent(newEvent, span: EKSpan.ThisEvent, commit: true)
    }
    
    func eventExists(event: Event) -> Bool {
        var match = false
        
        let predicate = store.predicateForEventsWithStartDate(event.startDate, endDate: event.endDate, calendars: nil)
        store.enumerateEventsMatchingPredicate(predicate) { existingEvent, stop in
            
            if existingEvent.title.lowercaseString == event.title.lowercaseString {
                match = true
                return
            }
        }
        
        if match {
            print("MATCH")
            return true
        } else {
            print("NO MATCH")
            return false
        }
    }

    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getCalendar() -> EKCalendar? {
        let defaults = NSUserDefaults.standardUserDefaults()

        if let id = defaults.stringForKey("calendarID") {
            print(id)
            return store.calendarWithIdentifier(id)
        } else {
            let calendar = EKCalendar(forEntityType: EKEntityType.Event, eventStore: self.store)
            
            calendar.title = "Dance Marathon"
            calendar.CGColor = Color.primary1.CGColor
            calendar.source = self.store.defaultCalendarForNewEvents.source
            
            do {
                try self.store.saveCalendar(calendar, commit: true)
                defaults.setObject(calendar.calendarIdentifier, forKey: "calendarID")
            } catch {
                
            }
            
            return calendar
        }
    }
}
