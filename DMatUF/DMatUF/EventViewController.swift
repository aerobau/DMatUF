 //
//  EventViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/24/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//
import UIKit
import CoreData
import CoreGraphics


class EventViewController: UITableViewController, NSFetchedResultsControllerDelegate, DropdownController {
    
    @IBOutlet weak var dropdownButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()
    var dropDownTableView = DropdownTableView(frame: CGRectZero, style: UITableViewStyle.Plain)

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
        
        dropDownTableView.dropdownDelegate = self
        dropdownButton.setTitleColor(Color.primary1, forState: .Normal)
        
        
        let l: CGFloat = 20
        
        UIGraphicsBeginImageContext(CGSize(width: l, height: l))
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        CGContextSetLineCap(context, kCGLineCapSquare)
        CGContextSetFillColorWithColor(context, Color.primary1.CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, Color.primary1.CGColor)
        CGContextMoveToPoint(context, l / 4.0, l / 4.0)
        CGContextAddLineToPoint(context, 3.0 * l / 4.0, l / 4.0)
        CGContextAddLineToPoint(context, l / 2.0, 3.0 * l / 4.0)
        CGContextClosePath(context)
        CGContextFillPath(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        dropdownButton.setImage(image, forState: UIControlState.Normal)
        dropdownButton.frame.size.width = view.frame.width
        updateCategories()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        deleteOldEvents()
        
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
        
        if let image = UIImage(fileName: cellEvent.imageName, type: "png") {
            cell.calendarImageView.image = image
            cell.dayLabel.text = nil
            cell.monthLabel.text = nil
            println("Index \(indexPath.row) image name \(cellEvent.imageName)")

        } else {
            cell.calendarImageView.image = UIImage(named: "Calendar")
            cell.dayLabel.text = "\(cellEvent.startDate.day())"
            cell.monthLabel.text = cellEvent.startDate.shortMonthToString()
        }
        return cell
    }

    func dropdown(dropdown: DropdownTableView, didDismissWithIndexPath indexPath: NSIndexPath, andTitle title: String) {
        
        if indexPath.row == 0 {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(nil), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
            
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(fetchCategory(title)), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.performFetch(nil)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            println("\(indexPath) - \(title)")
            self.dropdownButton.setTitle(title, forState: UIControlState.Normal)
           
            self.tableView.reloadData()
            println("DISMISS INDEX: \(indexPath.row), \(title)")

        }
    }

    @IBAction func sortButtonPressed(sender: UIButton) {
        if dropDownTableView.isOpened {
            dropDownTableView.hide()
        } else {
            dropDownTableView.showInView(tableView.superview!, withFrame: CGRect(origin: CGPointZero, size: view.bounds.size))
            dropDownTableView.contentInset.top = tableView.contentInset.top ?? 0
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventDetailSegue" {
            let destination = segue.destinationViewController as EventDetailViewController
            let indexPath = self.tableView?.indexPathForCell(sender as EventCell)
            
            destination.selectedEvent = indexPath != nil ? fetchedResultsController.objectAtIndexPath(indexPath!) as? Event : nil
            destination.fetchedResultsController = fetchedResultsController
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            println("OBJECT DELETED")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
}