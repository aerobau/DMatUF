//
//  HomeViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class HomeViewController: DMMainViewController  {
    
    @IBOutlet weak var countdownImageView: CountdownImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var announcementsLabel: UILabel!
    @IBOutlet weak var announcementsTableView: AnnouncementsTableView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var welcomeLabelHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Set Attributes
        welcomeLabel?.textColor = Color.primary2
        announcementsLabel?.textColor = Color.primary1
        topBar?.backgroundColor = Color.secondary1
        bottomBar?.backgroundColor = Color.secondary1
        announcementsTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
        if UIDevice.type == DeviceType.iPhone4s {
            welcomeLabel.hidden = true
            welcomeLabelHeight.constant = 0
        }
        
        // Google Analytics
        GA.sendScreenView(name: "HomeView")
        
        fetchCountdownContent()
        
        countdownImageView.updateLabelFrames()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        countdownImageView.layoutSubviews()
    }
    
    @IBAction override func kinteraButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "kinteraButton", value: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("userInfo") as? [String: AnyObject] != nil {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }
    
    func fetchCountdownContent() {
        
        let session = NSURLSession.sharedSession()
        let url: NSURL! = NSURL(string: "http://dev.floridadm.org/app/countdown.php")
        
        session.dataTaskWithURL(url) { (data, response, error)  in
            
            guard let data = data else { return }
            let rawJSON = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            if let results = rawJSON as? [AnyObject] {
                if let data = results[0] as? [String: AnyObject] {
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    if let date = data["date"] as? String {
                        defaults.setObject(date, forKey: "CountdownDate")
                    } else {
                        defaults.setObject(nil, forKey: "CountdownDate")

                    }
                    
                    if let message = data["message"] as? String {
                        defaults.setObject(message, forKey: "CountdownMessage")
                    } else {
                        defaults.setObject(nil, forKey: "CountdownMessage")
                    }
                    
                    
                    self.countdownImageView.updateCountdownData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    return
                }
            }
            }.resume()
    }

}

