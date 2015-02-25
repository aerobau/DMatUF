//
//  FundCell.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class KinteraViewController: UIViewController {
    
    @IBOutlet weak var thermometer: CAThermometer!
    @IBOutlet weak var table: CATable!
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "KinteraView")

        view.backgroundColor = Color.tvcOdd

        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refreshControl)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        navigationItem.leftBarButtonItem?.title = "Back"
     }

        override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFundraisingGraphics()
    }
    

    func updateFundraisingGraphics() {
        println("REFRESH")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var value: Int?
        
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            
            // Participant Name
            let partName = (dict["ParticipantName"] as? String) ?? ""
            table.name = partName
    
            // Participant Goal
            let partGoal = (dict["PersonalGoal"] as? NSString) ?? ""
            thermometer.goal = partGoal.integerValue
            table.goal = partGoal.integerValue
            
            // Participant Raised
            let partRaised = (dict["PersonalRaised"] as? NSString) ?? ""
            thermometer.value = partRaised.integerValue
            table.value = partRaised.integerValue
            
            // Personal URL
            let personalPageURL = (dict["PersonalPageUrl"] as? String) ?? ""
            table.url = personalPageURL
            
            // Last Updated
            let lastUpdated = (dict["PersonalRaisedToDate"] as? String) ?? ""
            table.lastUpdated = lastUpdated
        }

        thermometer.setup()

        
        table.separatorInset = UIEdgeInsets(top: 0, left: thermometer.frame.width / 2 + 20.0, bottom: 0, right: 20.0)

        var indexPaths: [NSIndexPath]?
        for i in 0...4 {
            indexPaths?.append(NSIndexPath(forRow: i, inSection: 0))
        }
        table.reloadRowsAtIndexPaths(indexPaths ?? [], withRowAnimation: UITableViewRowAnimation.Fade)

    }
    func refreshControlAction() {
        
        if Reachability.connectedToInternet() {
            self.refresh()
        } else {
            UIAlertView.errorMessage("Error", message: "Internet connection required!")
        }
    }
    

    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "password")
        defaults.setObject(nil, forKey: "userInfo")
        
        navigationController?.popViewControllerAnimated(true)
    }

    func refresh() {
    
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "RefreshMyKintera", value: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.stringForKey("username") {
            if let password = defaults.stringForKey("password") {
                login(username, password: password) {
                    
                }
            }
        } else {
            loginAlert()
        }
        
    }
  
    override func startLoading() {
        println("Start loading")
     }
    
    override func stopLoading() {
        println("Stop loading")
        updateFundraisingGraphics()
        refreshControl.endRefreshing()
    }
}
