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
    
    @IBOutlet weak var thermometer: CAThermometer!
    @IBOutlet weak var table: CATable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFundraisingGraphics()
        view.backgroundColor = Color.tvcOdd
    }
    
    
    func updateFundraisingGraphics() {
        
        
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
                thermometer.goal = partGoalInt
                table.goal = partGoalInt
                
            }
            
            // Participant Raised
            if let partRaised = dict["PersonalRaised"] as? NSString {
                let partRaisedInt = partRaised.integerValue
                thermometer.value = partRaisedInt
                table.value = partRaisedInt
            }
            
            // Personal URL
            if let personalPageURL = dict["PersonalPageUrl"] as? NSString {
                personalURL = personalPageURL
            }
            
            // Last Updated
            if let lastUpdated = dict["PersonalRaisedToDate"] as? NSString {
            }
        }
        thermometer.setup()
        table.reloadData()
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
