//
//  AboutViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/28/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation

class AboutViewController: UITableViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!

    let questions = ["If I register to dance, am I guaranteed a dancer spot at DM?",
        "I already registered to fundraise, do I need to register to dance?",
        "Do I have to be a UF student to dance?",
        "I don’t have my DM shirt, can I still check in for spirit points?",
        "How do I register to fundraise?",
        "Can I still dance if I am the Delegate for my organization’s team?",
        "How do spirit points work?",
        "What happens when someone registers to dance and isn’t given a spot?"]
    let answers = ["Not necessarily. Dancer spots are allocated based off of participation and fundraising goals set for each organization and individual.",
        "Yes, registering to fundraise and registering to dance are two separate things.",
        "Yes, you must be enrolled as a student during the Spring semester whenin which Dance Marathon takes place. This also applies to those registered with UF who are taking an internship in place of classes.",
        "You must be wearing a DM shirt to check in for spirit points. The purpose of wearing the shirt is to spread awareness around campus.",
        "See Fundraise tab for instructions.",
        "Yes!",
        "Spirit Points are used to keep track of each organization’s participation in our events and incentives throughout the year leading up to Dance Marathon. There is a friendly competition between teams and the winner will be announced at closing ceremonies for Dance Marathon.",
        "The money they paid for the registration fee will be allocated back to their organization’s total."]
    
    let types = ["General Questions", "Overalls", "UF & Shands OD", "Check Donations"]
    let contacts = ["floridadm@floridadm.org", "http://www.floridadm.org/meet-the-overalls", "352-265-7237\nhttps://ufhealth.org/shands-hospital-children-uf", "330C J. Wayne Reitz Union, P.O. Box 118505, Gainesville, FL 32611"]
    
    let paragraphTitle = "UF Health Shands Children’s Hospital, the local Children’s Miracle Network Hospital"
    let paragraph = "UF Health Shands Children’s Hospital at the University of Florida is the local Children’s Miracle Network Hospital participating hospital for the Gainesville/North Central Florida, Tallahassee/South Georgia and West Palm Beach areas. Children’s Miracle Network is an international non-profit organization dedicated to raising funds for and awareness of children’s hospitals. Children’s Miracle Network’s founding pledge, to keep all donations in the area in which they were raised, remains at the core of its philosophy.\nUF Health Shands Children’s Hospital is the state’s premier pediatric health center providing innovative and comprehensive care at the highest standards of quality and service in partnership with patient families, healthcare teams and communities. Community contributions help support pediatric research and the purchase of the latest technology to maintain this high standard of clinical care.\nUF Health Shands Children’s Hospital is committed to the best medical care when kids need it most and also provides a comfortable environment for families during hospital stays. Donations enhance or help provide many of the services, programs and amenities that make UF Health Shands Children’s Hospital a leader in pediatric care.\nFor more information, please visit: https://ufhealth.org/shands-hospital-children-uf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "AboutView")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        tableView.setNeedsDisplay()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return questions.count
        } else if segmentControl.selectedSegmentIndex == 1 {
            return types.count

        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if segmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FactsCellID", forIndexPath: indexPath) as! FactsCell
            
            cell.topLabel.text = questions[indexPath.row]
            cell.bottomLabel.text = answers[indexPath.row]

            return cell

        } else if segmentControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactCellID", forIndexPath: indexPath) as! ContactCell
            
            cell.typeLabel.text = types[indexPath.row]
            cell.infoTextView.text = contacts[indexPath.row]
            cell.typeLabel.textColor = Color.primary2

            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FactsCellID", forIndexPath: indexPath) as! FactsCell
            cell.topLabel.text = paragraphTitle
            cell.bottomLabel.text = paragraph
            
            return cell
        }
    }

    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        GA.sendEvent(category: GA.K.CAT.ACTION, action: GA.K.ACT.PRESSED, label: "Segment \(sender.selectedSegmentIndex)", value: nil)

        tableView.reloadData()
        tableView.setNeedsDisplay()
    }
}