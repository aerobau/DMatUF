//
//  EventsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//


import UIKit
import CoreData

// Cell
class EventCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}


class EventsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        requestEvents()
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventSegue" {
            let cell = sender as UITableViewCell
            var destination = segue.destinationViewController as SelectedEventViewController
            
            
            if let index = self.tableView?.indexPathForCell(cell)!{
                
                let event = fetchedResultController.objectAtIndexPath(index) as NSManagedObject                
                destination.id = event.valueForKey("id") as? Int
                

//                if let name = event { destination.name = name }
//                if let age = kid.age { destination.age = age }
//                if let story = kid.story { destination.story = story }
//                if let image = kid.image { destination.image = image }
                
            }
        }
    }
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as EventCell
        let event = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
        let id = event.valueForKey("id") as? Int
        cell.titleLabel.text = "\(id!)"
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
        managedObjectContext?.deleteObject(managedObject)
        managedObjectContext?.save(nil)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
    
    func requestEvents() {
        let url = NSURL(string: "http://mickmaccallum.com/ian/events.php")
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { data, response, error in
            var jsonError: NSError?
            
            var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: &jsonError)
           let json = JSON(rawJSON!)
            let title = json[1]["title"]
            println("QQQQQQQQQ \(title)")
//            println(json)
            
            
            if jsonError == nil {
                if let JSON = rawJSON as? [[String : String]] {
                    println(JSON)

                    for dict in JSON {
                    }
                }else{
                    println("Convert to JSON failed")
                }
            } else {
                // determine and handle error
            }
            }.resume()
    }


    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        var newEvent: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext!) as NSManagedObject
        newEvent.setValue(78, forKey: "id")
//        newEvent.setValue("Test", forKey: "title")
        
        self.managedObjectContext!.save(nil)
        
        
    }
}
