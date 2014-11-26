//
//  FundCell.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class FundCell: UICollectionViewCell {
    
    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBOutlet weak var participantNameLabel: UILabel!
    @IBOutlet weak var participantGoalLabel: UILabel!
    @IBOutlet weak var participantRaisedLabel: UILabel!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamGoalLabel: UILabel!
    @IBOutlet weak var teamRaisedLabel: UILabel!
    
    
    
    override func layoutSubviews() {
        println("LAYOUT SUBVIEWS")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var value: Int?

        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {

            // Participant Name
            if let partName = dict["ParticipantName"] as? String {
                participantNameLabel.text = partName
            }
            // Participant Goal
            if let partGoal = dict["PersonalGoal"] as? NSString {
                let partGoalInt = partGoal.integerValue
                participantGoalLabel.text = "$\(partGoalInt)"
                progressBar.max = partGoalInt
            }
            // Participant Raised
            if let partRaised = dict["PersonalRaised"] as? NSString {
                let partRaisedInt = partRaised.integerValue
                participantRaisedLabel.text = "$\(partRaisedInt)"
                progressBar.updateProgress(toValue: partRaisedInt, isAnimated: true)
            }
            
            // Team Name
            if let teamName = dict["TeamName"] as? String {
                teamNameLabel.text = teamName
            }
            // Team Goal
            if let teamGoal = dict["TeamGoal"] as? NSString {
                let teamGoalInt = teamGoal.integerValue
                teamGoalLabel.text = "$\(teamGoalInt)"
            }
            // Team Raised
            if let teamRaised = dict["TeamRaised"] as? NSString {
                let teamRaisedInt = teamRaised.integerValue
                teamRaisedLabel.text = "$\(teamRaisedInt)"
            }
        }
    }
}
