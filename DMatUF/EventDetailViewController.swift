//
//  EventDetailViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import Foundation
import EventKit
import EventKitUI
import CoreData

class EventDetailViewController: UIViewController {
    var store = EKEventStore()
    var fetchedResultsController: NSFetchedResultsController?
    var selectedEvent: Event?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "EventsDetailView")

        setInfo()
        
        view.backgroundColor = Color.tvcEven
        navigationItem.leftBarButtonItem?.title = "Back"

        titleLabel.textColor = Color.primary2
        titleLabel.font = Font.header
        
        dateLabel.textColor = UIColor.blackColor()
        dateLabel.font = Font.body1
        
        locationLabel.textColor = Color.primary1
        locationLabel.font = Font.subheader
        
    }

    func setInfo(){
        let startDate = selectedEvent?.startDate.toString(format: DateFormat.Custom("EEEE, MMMM d 'at' h:mm a"), timeZone: TimeZone.EST) ?? ""
        let endDate = selectedEvent?.endDate.toString(format: DateFormat.Custom("EEEE, MMMM d 'at' h:mm a"), timeZone: TimeZone.EST)
        
        titleLabel.text = selectedEvent?.title ?? ""
        dateLabel.text = startDate + (endDate != nil && selectedEvent?.startDate.timeIntervalSince1970 < selectedEvent?.endDate.timeIntervalSince1970 ? " -\n" + endDate! : "")
        locationLabel.text = selectedEvent?.location ?? ""
        descriptionTextView.text = selectedEvent?.moreInfo ?? ""
    }
}