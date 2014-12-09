 //
//  EventViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//
import UIKit
import CoreData

private let sectionHeaders = ["Upcoming Events", "Past Events"]



class EventViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.registerClass(Header.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedSectionHeaderHeight = 22.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        
        // TableView Separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor(patternImage: UIImage(named: "Separator")!)
        tableView.separatorInset = UIEdgeInsetsZero
        
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self

        var error: NSErrorPointer = nil
        if !fetchedResultController.performFetch(error)
        {
            println("Unresolved error: \(error), \(error.debugDescription)")
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refreshControl?.addTarget(self, action: "fetchJSON:", forControlEvents: UIControlEvents.ValueChanged)
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
            cell.backgroundColor = UIColor(hue: 40.0/255.0, saturation: 0.01, brightness: 0.97, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(hue: 70.0/255.0, saturation: 0.03, brightness: 0.93, alpha: 1.0)
        }
        
        cell.titleLabel.text = cellEvent.eTitle
        cell.dayLabel.text = "\(cellEvent.eStart.day())"
        cell.monthLabel.text = cellEvent.eStart.shortMonthToString()
        
        
        var time = cellEvent.eStart.toString(format: .Custom("h:mm a"))
        time += " to "
        time += cellEvent.eEnd.toString(format: .Custom("h:mm a"))

        if cellEvent.eStart.day() != cellEvent.eEnd.day() {
            time += " on "
            time += cellEvent.eEnd.toString(format: .Custom("M/dd"))
        }
        cell.timeLabel.text = time
//        cell.timeLabel.backgroundColor = UIColor.magentaColor()
//        let width =  NSString(string: time).sizeWithAttributes([NSFontAttributeName: cell.timeLabel.font.fontName]).width
//        cell.timeLabel.frame = CGRectMake(cell.timeLabel.frame.origin.x, cell.timeLabel.frame.origin.y, width, cell.timeLabel.frame.size.height)
//        cell.locationLabel.text = cellEvent.eLocation
        cell.locationLabel.text = "This is a very long location"

        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        let managedObject:Event = fetchedResultController.objectAtIndexPath(indexPath) as Event
//        managedObjectContext?.deleteObject(managedObject)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        tableView.setEditing(false, animated: true)
        
        var facebookAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Facebook", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            println("Triggered share action \(action) atIndexPath: \(indexPath)")
            return
        })
        facebookAction.backgroundColor = UIColor(hue: 223.0/360.0, saturation: 0.62, brightness: 0.62, alpha: 1.0)
        
        var twitterAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Twitter", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            println("Triggered share action \(action) atIndexPath: \(indexPath)")
            return
        })
        twitterAction.backgroundColor = UIColor(hue: 206.0/360.0, saturation: 0.64, brightness: 0.93, alpha: 1.0)

        var emailAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Email", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            println("Triggered share action \(action) atIndexPath: \(indexPath)")
            return
        })

        
        return [facebookAction, twitterAction, emailAction]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeader") as Header
        header.contentView.backgroundColor = UIColor(hue: 60.0/255.0, saturation: 0.03, brightness: 0.91, alpha: 1.0)
        
        let sectionInfo = fetchedResultController.sections![section] as? NSFetchedResultsSectionInfo
        
        let label = UILabel(frame: CGRectMake(8, 2, 200, 24))
        label.text = sectionInfo?.name
        header.addSubview(label)
        
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
                
                destination.id = event.eID.integerValue
                destination.eventTitle = event.eTitle
                destination.startDate = event.eStart
                destination.endDate = event.eEnd
                destination.eventDescription = event.eDescription
                destination.location = event.eLocation
            }
        }
    }
}
