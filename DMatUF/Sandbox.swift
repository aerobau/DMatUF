//
//  EventsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

/*

import UIKit

class EventsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    // Define Variables and Constants
    var array: Array<Dictionary<String, String>>?;
    let fileManager = (NSFileManager .defaultManager())
    let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Refresh Control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        // Refresh and Fetch
        self.refreshControl?.beginRefreshing()
        request()
        
        
        
    }
    
    func refresh(sender:AnyObject)
    {
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func request(){
        var bodyData = "name=value" //To get them in php: $_POST['name']
        
        let urlPath: String = "http://mickmaccallum.com/ian/events.php"
        let url: NSURL = NSURL(string: urlPath)
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var output = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                self.array = self.JSONParseArray(output)
                for (var i = 0; i < self.array?.count; i++){
                    println(self.array![i]["id"]!)
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
        }
    }
    
    func JSONParseArray(jsonString: String) -> Array<Dictionary<String, String>>? {
        var e: NSError?
        var data: NSData!=jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &e) as Array<Dictionary<String, String>>
        if e == 0 {
            return nil
        } else {
            return jsonObj
        }
    }
    
    
    
    // TableView Datasource and Delegate Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.array != nil) ? self.array!.count : 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as UITableViewCell
        
        let name = self.array?[indexPath.row]["name"]
        cell.textLabel?.text = name
        
        return cell
    }
}
*/