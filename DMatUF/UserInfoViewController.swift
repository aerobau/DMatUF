//
//  UserInfoViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/11/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController {
    var info: [String: AnyObject] = Dictionary()
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var raisedLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = info["ParticipantName"] as? String {
            userLabel.text = name
        }
        if let goal = info["PersonalGoal"] as? String {
            goalLabel.text = goal
        }
        if let raised = info["PersonalRaised"] as? String {
            raisedLabel.text = raised
        }
    }
}