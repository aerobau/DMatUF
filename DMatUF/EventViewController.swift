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

    private let sectionHeaders = ["Upcoming Events", "Past Events"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        tableView.separatorColor = Color.tvcSeparator
        tableView.estimatedRowHeight = 64.0
        
        fetchedResultsController = getFetchedResultController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchJSON:", forControlEvents: UIControlEvents.ValueChanged)
        
        fetchJSON(nil)

        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CAF.version < 8.0 ? 64.0 : UITableViewAutomaticDimension

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
  
        cell.titleLabel.text = cellEvent.eTitle
        cell.dayLabel.text = "\(cellEvent.eStart.day())"
        cell.monthLabel.text = cellEvent.eStart.shortMonthToString()
        
        var str = "\(NSDate.relativeDateString(start: cellEvent.eStart, end: cellEvent.eEnd))"
        if cellEvent.eLocation == "" {str += "at \(cellEvent.eLocation)"}

        cell.timeLabel.text =  str
        return cell
    }
            
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeader") as UITableViewHeaderFooterView

        header.contentView.backgroundColor = Color.tvHeader
        header.textLabel.text = sectionHeaders[section]
        
        return header
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventDetailSegue" {
            let destination = segue.destinationViewController as EventDetailViewController
            if let index = self.tableView?.indexPathForCell(sender as EventCell)!{
                destination.event = fetchedResultsController.objectAtIndexPath(index) as? Event
            }
        }
    }
}
