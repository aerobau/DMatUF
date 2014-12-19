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

private let sectionHeaders = ["Upcoming Events", "Past Events"]



class EventViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
        tableView.rowHeight = CAF.version < 8.0 ? 64.0 : UITableViewAutomaticDimension
//        tableView.estimatedSectionHeaderHeight = 26.0
//        tableView.sectionHeaderHeight = 26.0
//        tableView.estimatedSectionFooterHeight = 0.0
//        tableView.sectionFooterHeight = 0.0
//        
        // TableView Separators
        tableView.separatorColor = Color.tvcSeparator
        
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self

        var error: NSErrorPointer = nil
        if !fetchedResultController.performFetch(error)
        {
            println("Unresolved error: \(error), \(error.debugDescription)")
        }
        fetchJSON(tableView)
    }
    
    func pan(sender: AnyObject) {
        println("pannnnnn")
    }
    
    /* Table View Data Source & Delegate */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCellID", forIndexPath: indexPath) as EventCell
        let cellEvent = fetchedResultController.objectAtIndexPath(indexPath) as Event
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Color.tvcEven
        } else {
            cell.backgroundColor = Color.tvcOdd
        }
        
  
        cell.titleLabel.text = cellEvent.eTitle
        cell.dayLabel.text = "\(cellEvent.eStart.day())"
        cell.monthLabel.text = cellEvent.eStart.shortMonthToString()
        
        cell.timeLabel.text = NSDate.relativeDateString(start: cellEvent.eStart, end: cellEvent.eEnd)
//        cell.locationLabel.text = cellEvent.eLocation
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        tableView.setEditing(false, animated: true)
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            println("Triggered share action \(action) atIndexPath: \(indexPath)")
            return
        })
        
        shareAction.backgroundColor = UIColor.blueColor()
        
        var shareAction2 = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share2", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            println("Triggered share action \(action) atIndexPath: \(indexPath)")
            return
        })
        
        shareAction2.backgroundColor = UIColor.blueColor()

        return [shareAction, shareAction2]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeader") as UITableViewHeaderFooterView
        
        let sectionInfo = fetchedResultController.sections![section] as? NSFetchedResultsSectionInfo

        header.contentView.backgroundColor = Color.tvHeader
        header.textLabel.text = sectionInfo?.name
        header.textLabel.textColor = UIColor.blackColor()
        
        return header
        
    }
    
    
    /* Segue Functions */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventDetailSegue" {
            let cell = sender as EventCell
            var destination = segue.destinationViewController as EventDetailViewController
            
            
            if let index = self.tableView?.indexPathForCell(cell)!{
                
                let event = fetchedResultController.objectAtIndexPath(index) as Event
                
                println(event.eStart)
                
                destination.event = event
            }
        }
    }
}
