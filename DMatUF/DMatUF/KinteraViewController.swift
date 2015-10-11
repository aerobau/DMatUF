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
//        navigationItem.leftBarButtonItem?.title = "Back"
     }

        override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFundraisingGraphics()
    }
    

    func updateFundraisingGraphics() {
        print("REFRESH")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
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
        table.reloadData()

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
                updateKintera(username, password: password)
            }
        } else {
            loginAlert()
        }
        
    }
  
    override func startLoading() {
        print("Start loading")
     }
    
    override func stopLoading() {
        print("Stop loading")
        updateFundraisingGraphics()
        refreshControl.endRefreshing()
    }
    
    func updateKintera(username: String, password: String) {
        startLoading()
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "update", value: nil)
        
        let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: "http://dev.floridadm.org/app/kintera.php?username=\(username)&password=\(password)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) ?? NSURL()
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 8.0)
        
        Properties.task = session.dataTaskWithRequest(request) { [unowned self] data, response, error in

            if NSString(data: data!, encoding: 8) as! String == "Error" {
                Properties.task?.cancel()
                dispatch_async(dispatch_get_main_queue()) {
                    UIAlertView.errorMessage("Login Failed", message: "Invalid username or password.\nTry again.")
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if let dataUnwrapped = data {
                    let rawJSON: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .AllowFragments)
                    
                    if let result = rawJSON as? [String: AnyObject] {
                        print(result)
                        // Save Login info to NSUserDefaults
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(result, forKey: "userInfo")
                        
                        // Update Components
                        self.stopLoading()
                        GA.sendEvent(category: GA.K.CAT.ACTION, action: GA.K.ACT.LOGIN, label: "login success", value: nil)
                    } else {
                        self.stopLoading()
                    }
                } else {
                    self.stopLoading()
                }
                
                if error != nil {
                    UIAlertView.errorMessage("Error \(error!.code)", message: "\(error!.localizedDescription)")
                }
            }
        }
        Properties.task?.resume()
    }
}
