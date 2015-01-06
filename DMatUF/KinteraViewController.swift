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
    @IBOutlet weak var refreshButton: CAButton!
    var task: NSURLSessionDataTask?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.tvcOdd
//        navigationItem.leftBarButtonItem?.title = "Back"
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var value: Int?
        
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            
            // Participant Name
            let partName = dict["ParticipantName"] as? String ?? ""
            table.name = partName
    
            // Participant Goal
            let partGoal = dict["PersonalGoal"] as? NSString ?? ""
            thermometer.goal = partGoal.integerValue
            table.goal = partGoal.integerValue
            
            // Participant Raised
            let partRaised = dict["PersonalRaised"] as? NSString ?? ""
            thermometer.value = partRaised.integerValue
            table.value = partRaised.integerValue
            
            // Personal URL
            let personalPageURL = dict["PersonalPageUrl"] as? NSString ?? ""
            table.url = personalPageURL
            
            // Last Updated
            let lastUpdated = dict["PersonalRaisedToDate"] as? NSString ?? ""
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
    @IBAction func refreshButtonPressed(sender: CARefreshButton) {
        
        if Reachability.connectedToInternet() {
            refresh()
        } else {
            CAF.errorMessage("Error", message: "Internet connection required!")
        }
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "password")
        defaults.setObject(nil, forKey: "userInfo")
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func refresh() {
        
        startLoading()
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "login", value: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")
        let password = defaults.stringForKey("password")
        
        if !(username != nil && password != nil) {
            CAF.errorMessage("Login Failed", message: "Username or password does not exist.")
            return
        }
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://mickmaccallum.com/ian/kintera.php?username=\(username!)&password=\(password!)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) ?? NSURL()
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 8.0)
        
        task = session.dataTaskWithRequest(request) { [unowned self] data, response, error in
            println("DATA \(data)")
            println(NSString(data: data, encoding: 8))
            println("RESPONSE \(response)")
            println(error)
            
            if NSString(data: data, encoding: 8) as String == "Error" {
                self.task?.cancel()
                dispatch_async(dispatch_get_main_queue()) {
                    CAF.errorMessage("Login Failed", message: "Invalid username or password.\nTry again.")
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if let dataUnwrapped = data {
                    var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .allZeros, error: nil)
                    
                    if let result = rawJSON as? [String: AnyObject] {
                        println(result)
                        // Save Login info to NSUserDefaults
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(result, forKey: "userInfo")
                        
                        // Update Components
                        self.stopLoading()
                        
                        self.updateFundraisingGraphics()
                    } else {
                        self.stopLoading()
                    }
                } else {
                    self.stopLoading()
                }
                
                if error != nil {
                    CAF.errorMessage("Error \(error.code)", message: "\(error.localizedDescription)")
                }
            }
        }
        task?.resume()
    }
    
    func startLoading() {
//        refreshButton.imageView?.image = nil
        refreshButton.enabled = false
        println("Start loading")
     }
    
    func stopLoading() {
//        refreshButton.imageView?.image = UIImage(named: "Refresh")
        refreshButton.enabled = true


        println("Stop loading")
        task?.cancel()
    }
}
