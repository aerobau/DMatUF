//
//  KinteraLogin.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/29/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class KinteraLoginViewController: UIViewController, UITextFieldDelegate {
    var username: String = ""
    var password: String = ""
    var dictTemp: [String: AnyObject]?
    
    // Handle Connection
    var urlTemp: NSURL?
    var connectionTemp: NSURLConnection?

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        if let user = defaults.objectForKey("username") as? String {
            username = user
            usernameField.text = user
        }
        
        if let pass = defaults.objectForKey("password") as? String {
            password = pass
            passwordField.text = pass
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        username = usernameField.text
        password = passwordField.text
        activityIndicator.startAnimating()
        requestData()
    }
    
    func requestData() {
        
        let session = NSURLSession.sharedSession()

        urlTemp = NSURL(string: "http://mickmaccallum.com/ian/kintera.php?&username=\(username)&password=\(password)")
        
        if let url = urlTemp {
            
            var request = NSMutableURLRequest(URL: url)
            let queue: NSOperationQueue = NSOperationQueue.mainQueue()

            connectionTemp = NSURLConnection(request: request, delegate: self, startImmediately: true)

            if let connection = connectionTemp {
            
                NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) in
                    
                    var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil)
                    
                    if let result = rawJSON as? [String: AnyObject] {
                        self.dictTemp = result
                        self.activityIndicator.stopAnimating()
                        println(self.dictTemp)

                        // Save Login info to NSUserDefaults
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(self.usernameField.text, forKey: "username")
                        defaults.setObject(self.passwordField.text, forKey: "password")
                        defaults.setObject(result, forKey: "userInfo")
                        
                        self.dismissViewControllerAnimated(true, completion: {})

                    } else {
                        println("JSON NOT CORRECT FORMAT")
                    }
                })
            } else {
                println("CONNECTION FAILED")
            }
        } else {
            println("INVALID URL")
        }
    }
    


    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("SEGUE")
        if (segue.identifier == "LoginSegue"){
            var destination = segue.destinationViewController as UserInfoViewController
            
            if let dict = dictTemp {
                destination.info = dict
            }

        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }

}