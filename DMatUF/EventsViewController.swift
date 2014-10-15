//
//  EventsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import CoreData

// Made to fit temp data. Will need to be reworked when web service changes
class Event2 {
    
    var id: Int?
    var name: String?
    var categoryID: Int?
    var brandID: Int?
    
    convenience init(data: [String : String]) {
        self.init()
        
        id = data["id"]?.toInt()
        name = data["name"]
        categoryID = data["category_id"]?.toInt()
        brandID = data["brand_id"]?.toInt()
    }
}


class EventsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var events: [Event2] = [Event2]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { [ unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    // Core Data stuff DO NOT DELETE
    func save(){
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        var newEvent: Event! = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as Event
        newEvent.id = 0
        newEvent.title = "My new event"
        newEvent.startDate = NSDate()
        newEvent.stopDate = NSDate()
        newEvent.complete = false
        
        context.save(nil)
        
        
        
    }
    
    // Core Data stuff DO NOT DELETE
    func load(){
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!

        var request = NSFetchRequest(entityName: "Event")
        request.returnsObjectsAsFaults = false
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            for result in results {
                println(result)
            }
        }else{
            println("0 results returned")
        }
    }
    // Core Data stuff DO NOT DELETE

    
    
    
    
    
    
    
    override func loadView() {
        super.loadView()
        
        requestEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func requestEvents() {
        let url = NSURL(string: "http://mickmaccallum.com/ian/events.php")
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { data, response, error in
            var jsonError: NSError?
            
            var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: &jsonError)
            
            if jsonError == nil {
                if let JSON = rawJSON as? [[String : String]] {
                    for dict in JSON {
                        self.events.append(Event2(data: dict))
                    }
                }
            } else {
                // determine and handle error
            }
        }.resume()
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                // stuff
            }
        }
    }
    
    // MARK: - Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as UITableViewCell
        
        let event = events[indexPath.row]
        
        cell.textLabel?.text = event.name?
        cell.detailTextLabel?.text = String(event.id ?? 0)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
