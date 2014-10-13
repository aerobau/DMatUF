//
//  EventsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    // Define Variables and Constants
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
    
    // TableView Datasource and Delegate Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (self.array != nil) ? self.array!.count : 0;
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as UITableViewCell
        
//        let name = self.array?[indexPath.row]["name"]
        cell.textLabel?.text = "Text"
            
        return cell
    }
}
