//
//  FundCell.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class FundViewController: UIViewController {
    var personalURL: String = ""
    var teamURL: String = ""
    
    @IBOutlet weak var partProgressBar: ProgressBar!
    @IBOutlet weak var teamProgressBar: ProgressBar!
    
    override func viewDidLayoutSubviews() {
        println("LAYOUT SUBVIEWS")
        partProgressBar.fillColor = AppDelegate().primaryColor
        teamProgressBar.fillColor = AppDelegate().secondaryColor
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var value: Int?
        
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            println(dict)
            
            // Participant Name
            if let partName = dict["ParticipantName"] as? String {
            }
            // Participant Goal
            if let partGoal = dict["PersonalGoal"] as? NSString {
                let partGoalInt = partGoal.integerValue
                partProgressBar.max = partGoalInt
            }
            // Participant Raised
            if let partRaised = dict["PersonalRaised"] as? NSString {
                let partRaisedInt = partRaised.integerValue
                partProgressBar.currentValue = partRaisedInt
            }
            // Personal URL
            if let personalPageURL = dict["PersonalPageUrl"] as? NSString {
                personalURL = personalPageURL
            }
            
            // Team Name
            if let teamName = dict["TeamName"] as? String {
            }
            // Team Goal
            if let teamGoal = dict["TeamGoal"] as? NSString {
                let teamGoalInt = teamGoal.integerValue
                teamProgressBar.max = teamGoalInt
            }
            // Team Raised
            if let teamRaised = dict["TeamRaised"] as? NSString {
                let teamRaisedInt = teamRaised.integerValue
                teamProgressBar.currentValue = teamRaisedInt
            }
            // Team URL
            if let teamPageURL = dict["TeamPageUrl"] as? NSString {
                teamURL = teamPageURL
            }
            
            // Last Updated
            if let lastUpdated = dict["PersonalRaisedToDate"] as? NSString {
            }
            
        }
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "username")
        defaults.setObject(nil, forKey: "password")
        defaults.setObject(nil, forKey: "userInfo")
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func participantDonateButtonPressed(sender: UIButton) {
    }
    @IBAction func teamDonateButtonPressed(sender: UIButton) {
    }
    
}
