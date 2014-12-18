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
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var thermometer: CAThermometer!
    @IBOutlet weak var table: CATable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.tvcOdd
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFundraisingGraphics()
    }
    
    
    func updateFundraisingGraphics() {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var value: Int?
        
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            println(dict)
            
            // Participant Name
            if let partName = dict["ParticipantName"] as? String {
                table.name = partName
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
                table.url = personalPageURL
            }
            
            // Last Updated
            if let lastUpdated = dict["PersonalRaisedToDate"] as? NSString {
            }
        }
        thermometer.setup()
        table.reloadData()
        table.separatorInset = UIEdgeInsets(top: 0, left: thermometer.frame.width / 2 + 20.0, bottom: 0, right: 20.0)
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "password")
        defaults.setObject(nil, forKey: "userInfo")
        
        navigationController?.popViewControllerAnimated(true)
    }
}
