//
//  DMSidePanelTableViewController.swift
//  DMatUF
//
//  Created by Alexander Robau on 9/29/15.
//  Copyright © 2015 DMatUF. All rights reserved.
//

import UIKit

// Protocol for the delegate that will change the main view.  DMContainerViewController conforms to
// this protocol and will change the main view approprieately when this defined method is called
protocol DMPanelDelegate {
    func changeMainViewController(optionSelected: DMMainViewControllerOption)
}

class DMSidePanelTableViewController: UITableViewController {
    // A delegate that will call upon the container to change i's main view, depending on the option
    // selected by the user
    var panelDelegate: DMPanelDelegate?

    
    // MARK: TABLE VIEW HANDLING //
    
    
    // The list of options that go to all of the different view controllers availible in the app
    let options: [DMMainViewControllerOption] =
    [.Home, .Events, .Game, .Map, .MeetTheKids, .Fundraise, .About]
    

    // Functionto get the number of rows in a given section of the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns the number of options
        return options.count
    }

    
    // Function that is called when a new table cell is needed, dequeue's a reusable cell and
    // configures it according to the correct option
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("panelCellReuse",
            forIndexPath: indexPath) as! DMSidePanelTableViewCell

        // Configuring the cell to contain the correct label value
        cell.label.text = options[indexPath.row].rawValue
        let iconName = options[indexPath.row].iconName
        cell.iconView.image = UIImage(named: iconName)
        
        return cell
    }
    
    // Function that is called when an option in the table is selected, utilizes the delegate to 
    // call upon the container to change the current view controller being displayed in the 
    // main view
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        panelDelegate?.changeMainViewController(options[indexPath.row])
    }

}
