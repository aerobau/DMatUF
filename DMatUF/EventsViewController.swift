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
    
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}



class EventsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        fetchJSON()
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        
    }
    
    func fetchJSON(){
        // Set URL and session
        let url = NSURL(string: "http://mickmaccallum.com/ian/events.php")
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { data, response, error in
            var jsonError: NSError?
            // Fetch raw JSON
            var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: &jsonError)
            
            if jsonError == nil {
                println("raw JSON success")
                if let arrayJSON = rawJSON as? [[String : AnyObject]] {
                    // JSON fetched and converted to array
                    println("Convert to JSON success")
                    
                    for var i = 0; i < arrayJSON.count; ++i{
                        
                        if let objID: NSNumber = arrayJSON[i]["id"] as? NSNumber{
                            println("objID recovered")
                           
                            println(objID)
                            if let event: Event = self.fetchObject(objID){
                                println("Event found in Core Data stack with id = \(objID)")
                            } else {
                                println("Event NOT found in Core Data stack with id = \(objID)")
                            }

                            
                        } else {
                            println("objID not recovered")
                        }
                    }
                    
                    
//                    for obj in JSON{
//                        println("obj in JSON")
//                    }
                    
                }else{
                    println("Convert to JSON failed")
                }
            } else {
                println("raw JSON error")
            }
        }.resume()
    }
    
    func fetchObject(objID: Int) -> Event?{
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: true)
        // Sorting fetch request with predicates
        let predicate = NSPredicate(format: "id == \(objID)", argumentArray: nil)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 1
        var error = NSErrorPointer()
        let fetchedObject = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: error)
        if let fetchedObj: Event = fetchedObject![0] as? Event {
            println("Fetched object with ID = \(objID). The title of this object is '\(fetchedObj.title)'")
            return fetchedObj
        }else {
            return nil
        }
    }
    
    func compareFetchedEvent(fetchedEvent: [String: AnyObject]){
        let id: Int? = JSON(fetchedEvent["id"]!).asInt
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: eventsFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func eventsFetchRequest() -> NSFetchRequest {
        var fetchRequest = NSFetchRequest(entityName: "Event")
        let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let event = fetchedResultController.objectAtIndexPath(indexPath) as Event
        
        // Configure cell
        cell.idLabel.text = "\(event.id)"
        cell.titleLabel?.text = event.title
        cell.lastUpdatedLabel?.text = String(Int(event.lastUpdated.timeIntervalSince1970))
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:Event = fetchedResultController.objectAtIndexPath(indexPath) as Event
        managedObjectContext?.deleteObject(managedObject)
        managedObjectContext?.save(nil)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        for i in 1...4{
            var newEvent: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext!) as Event
            newEvent.id = i
            newEvent.title = "Some title"
            newEvent.lastUpdated = NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)
        sleep(1)
        }
        self.managedObjectContext!.save(nil)
    }
   
    @IBAction func updateButtonPressed(sender: UIBarButtonItem) {
        if let object: Event = fetchedResultController.objectAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as? Event{
            object.updateFromDictionary(["title": "UPDATED TITLE"])
            println("Object updated + \(object.id)")
            self.managedObjectContext!.save(nil)

        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EventSegue" {
            let cell = sender as UITableViewCell
            var destination = segue.destinationViewController as SelectedEventViewController
            
            
            if let index = self.tableView?.indexPathForCell(cell)!{
                
                let event = fetchedResultController.objectAtIndexPath(index) as Event
                destination.id = event.id
                
                fetchObject(event.id)
                
//                if let name = event { destination.name = name }
//                if let age = kid.age { destination.age = age }
//                if let story = kid.story { destination.story = story }
//                if let image = kid.image { destination.image = image }
                
            }
        }
    }

}
