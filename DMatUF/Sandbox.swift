// JSON format
/*
{
    "aps":
    {
        "alert":
        {
            "action-loc-key": "Open",
            "body": "Hello, World!"
        },
        "badge": 2
    }
}

{"aps":{"alert":"Hello, world!","sound":"default"}}
*/

/*
import UIKit
import CoreData

class Sandbox: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    
}

import UIKit
import CoreData

// Made to fit temp data. Will need to be reworked when web service changes
//class Event2 {
//
//    var id: Int?
//    var name: String?
////    var startDate: NSDate?
////    var endDate: NSDate?
////    var lastModified: NSDate?
//    var description: String?
//    var points: Int?
//    var location: String?
//
//    convenience init(data: [String : String]) {
//        self.init()
//
//        id = data["id"]?.toInt()
//        name = data["name"]! as String?
////        startDate = data["startDate"] as NSDate?
////        endDate = data["endDate"] as NSDate?
////        lastModified = data["lastModified"] as NSDate?
//        description = data["description"]! as String?
//        points = data["points"]?.toInt()
//        location = data["description"]! as String?
//
//    }
//}


//class EventsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
//
//    var events: [Event2] = [Event2]() {
//        didSet {
//            dispatch_async(dispatch_get_main_queue()) { [ unowned self] in
//                self.tableView.reloadData()
//            }
//        }
//    }
//



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
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
    self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.reloadData()
    //        self.refreshControl?.endRefreshing()
}

func refresh()
{
    println("Refresh table view")
    self.refreshControl?.endRefreshing()
}

func requestEvents() {
    let url = NSURL(string: "http://mickmaccallum.com/ian/events.php")
    let session = NSURLSession.sharedSession()
    
    session.dataTaskWithURL(url) { data, response, error in
        var jsonError: NSError?
        
        var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: &jsonError)
        println(rawJSON)
        if jsonError == nil {
            
            if let JSON = rawJSON! as? [[String : String]] {
                for dict in JSON {
                    self.events.append(Event2(data: dict))
                    
                }
            }else{
                println("Convert to JSON failed")
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
    //        return events.count ?? 0
    return 10
}

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as UITableViewCell
    
    //        let event = events[indexPath.row]
    
    //        cell.textLabel?.text = event.name!
    cell.textLabel?.text = "text"
    //        cell.detailTextLabel?.text = String(event.id ?? 0)
    
    return cell
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
}
}


*/