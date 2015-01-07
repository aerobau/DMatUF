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
    var task: NSURLSessionDataTask?
    var kinteraButtonItem: UIBarButtonItem?


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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopLoading()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kinteraButtonItem = navigationItem.rightBarButtonItem
    }

    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CAF.version < 8.0 ? 64.0 : UITableViewAutomaticDimension

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println("Sections: \(fetchedResultsController.sections?.count)")
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
        cell.dayLabel.text = "\(cellEvent.startDate.day())"
        cell.monthLabel.text = cellEvent.startDate.shortMonthToString()
        
        cell.timeLabel.text =  dateLabelText(cellEvent.startDate, end: cellEvent.endDate)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventDetailSegue" {
            let destination = segue.destinationViewController as EventDetailViewController
            if let index = self.tableView?.indexPathForCell(sender as EventCell)!{
                destination.event = fetchedResultsController.objectAtIndexPath(index) as? Event
            }
        }
    }
    
    @IBAction func kinteraButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "kinteraButton", value: nil)

        let defaults = NSUserDefaults.standardUserDefaults()
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }
    
    @IBAction func donateButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "donate", value: nil)
        
        CAF.openURL(["http://floridadm.kintera.org/faf/home/default.asp?ievent=1114670"])
    }
}
