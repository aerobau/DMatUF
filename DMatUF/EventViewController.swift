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
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self

        var error: NSErrorPointer = nil
        if !self.fetchedResultController.performFetch(error)
        {
            /*
            Replace this implementation with code to handle the error appropriately.
            
            abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
            */
            println("Unresolved error: \(error), \(error.debugDescription)")
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        self.refreshControl?.addTarget(self, action: "fetchJSON:", forControlEvents: UIControlEvents.ValueChanged)
        fetchJSON(tableView)
    }
    
    /* Table View Data Source & Delegate */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        println("Sections: \(fetchedResultController.sections?)")
        println("IndexTitles: \(fetchedResultController.sectionIndexTitles)")
        return numberOfSections ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        println("section = \(section)")
        
        
       let sectionInfo = fetchedResultController.sections![section] as? NSFetchedResultsSectionInfo
        return sectionInfo?.name
        
        
//            return "header"
//        return fetchedResultController
        
//        return fetchedResultController
//            as? String
//        fetchedResultController.sectionNameKeyPath
//        return "Header"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCellID", forIndexPath: indexPath) as EventCell
        let cellEvent = fetchedResultController.objectAtIndexPath(indexPath) as Event
        
        cell.titleLabel.text = cellEvent.eTitle
        cell.idLabel.text = "\(cellEvent.eID)"
        cell.secLabel.text = cellEvent.eSecID ?? "nil"
        
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
            }
        }
    }
    
    
    
    
}
