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
        tableView.separatorColor = UIColor(patternImage: UIImage(named: "separator")!)
        tableView.separatorInset = UIEdgeInsetsZero
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self

        var error: NSErrorPointer = nil
        if !self.fetchedResultController.performFetch(error)
        {
            println("Unresolved error: \(error), \(error.debugDescription)")
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refreshControl?.addTarget(self, action: "fetchJSON:", forControlEvents: UIControlEvents.ValueChanged)
        fetchJSON(tableView)
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultController.sections![section] as? NSFetchedResultsSectionInfo
        return sectionInfo?.name
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
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:Event = fetchedResultController.objectAtIndexPath(indexPath) as Event
        managedObjectContext?.deleteObject(managedObject)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeader") as Header
//        var label = UILabel(frame: CGRectMake(20, 0, header.frame.width - 40, header.frame.height))
//        header.addSubview(label)
//        label.text = "tyujh67890"
//        label.backgroundColor = UIColor.yellowColor()
        
        
        
        header.contentView.backgroundColor = UIColor(hue: 60.0/255.0, saturation: 0.03, brightness: 0.91, alpha: 1.0)
//        header.textLabel.backgroundColor = UIColor.greenColor()
//        header.textLabel.frame = CGRectMake(20, 0, header.contentView.frame.width, header.contentView.frame.height)
//        header.textLabel.text = fetchedResultController.sectionNameKeyPath
        
//        let header = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 28))
//        let label = UILabel(frame: CGRectMake(6, 2, header.contentView.frame.width - 12, header.contentView.frame.height - 4))
//        header.contentView.addSubview(label)
//        header.contentView.backgroundColor = UIColor(hue: 60.0/255.0, saturation: 0.03, brightness: 0.91, alpha: 1.0)
//        label.text = fetchedResultController.sectionNameKeyPath
//        label.font = UIFont(name: "HelveticaNeue", size: 13)
//        label.backgroundColor = UIColor.greenColor()
        
        
        header.textLabel.text = fetchedResultController.sectionNameKeyPath
        return header
        
    }
    
    
    /* Segue Functions */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventDetailSegue" {
            let cell = sender as EventCell
            var destination = segue.destinationViewController as EventDetailViewController
            
            
            if let index = self.tableView?.indexPathForCell(cell)!{
                
                let event = fetchedResultController.objectAtIndexPath(index) as Event
                println()
                
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
