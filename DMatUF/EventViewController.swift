 //
//  EventViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//
import UIKit
import CoreData
import QuartzCore


class EventViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "EventsView")

        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        tableView.separatorColor = Color.tvcSeparator
        tableView.estimatedRowHeight = 64.0
        
        fetchedResultsController = getFetchedResultController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = Color.primary2
        refreshControl?.addTarget(self, action: "fetchJSON:", forControlEvents: UIControlEvents.ValueChanged)
        
        fetchJSON(nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        CAF.printDocsDirectory()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        println(documentsPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIDevice.version < 8.0 ? 64.0 : UITableViewAutomaticDimension

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCellID", forIndexPath: indexPath) as EventCell
        let cellEvent = fetchedResultsController.objectAtIndexPath(indexPath) as Event
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Color.tvcEven
        } else {
            cell.backgroundColor = Color.tvcOdd
        }
  
        cell.titleLabel.text = cellEvent.title
        cell.timeLabel.text =  dateLabelText(cellEvent.startDate, end: cellEvent.endDate)
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String).stringByAppendingString("/\(cellEvent.imageName).png")
        
        if let image = UIImage(contentsOfFile: imagePath) {
            cell.calendarImageView.image = image
            cell.dayLabel.text = nil
            cell.monthLabel.text = nil
        } else {
            cell.calendarImageView.image = UIImage(named: "Calendar")
            cell.dayLabel.text = "\(cellEvent.startDate.day())"
            cell.monthLabel.text = cellEvent.startDate.shortMonthToString()
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventDetailSegue" {
            let destination = segue.destinationViewController as EventDetailViewController
            let indexPath = self.tableView?.indexPathForCell(sender as EventCell)
            
            destination.event = indexPath != nil ? fetchedResultsController.objectAtIndexPath(indexPath!) as? Event : nil
        }
    }
}
