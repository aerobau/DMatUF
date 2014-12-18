//
//  HomeViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIAlertViewDelegate  {
    
    
    // Create Variables
    var loginTask: NSURLSessionDataTask?
    var loggedIn: Bool = false
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        // Google Analytics
        GA.sendScreenView(name: "HomeViewTest")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    func login(username: String, password: String) {
        startLoading()
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "login", value: nil)
    
        if let url = NSURL(string: "http://mickmaccallum.com/ian/kintera.php?&username=\(username)&password=\(password)") {
        
            let session = NSURLSession.sharedSession()
            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10.0)

            loginTask = session.dataTaskWithRequest(request) { [unowned self] data, response, error in
                dispatch_async(dispatch_get_main_queue()) {
                    println("Error \(error)")
                    
                    if let dataUnwrapped = data {
                        var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .allZeros, error: nil)
                        
                        if let result = rawJSON as? [String: AnyObject] {
                            println(result)
                            // Save Login info to NSUserDefaults
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(username, forKey: "username")
                            defaults.setObject(password, forKey: "password")
                            defaults.setObject(result, forKey: "userInfo")
                            
                            // Update Components
                            self.stopLoading()
                            
                            self.performSegueWithIdentifier("FundSegue", sender: self)
                            
                        } else {
                            self.stopLoading()
                        }
                    } else {
                        self.stopLoading()
                    }
                
                
                if error != nil {
                    self.errorMessage("\(error.code)", message: "\(error.localizedDescription)")
                }
                }
            }
            
            loginTask?.resume()

        
        } else {
            self.stopLoading()
        }
    }
    
    // Handle UIAlerts
    func loginAlert() {
        
        if NSClassFromString("UIAlertController") == nil {
            
            return
        }
        
        let alertController = UIAlertController(title: "Kintera Login", message: "Enter your username and password:", preferredStyle: .Alert)
        
        // Login Button
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
            
            self.login(loginTextField.text, password: passwordTextField.text)
        }
        loginAction.enabled = false
        
        // Forgot Button
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .Destructive) { (_) in
            CAF.openURL(["http://floridadm.kintera.org/faf/login/loginFindPassword.asp?ievent=1114670&lis=1&kntae1114670=BA9334B40FC64C91BE87CF7E42172BE5"])
        }
        
        // Cancel Button
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
        }
        
        // Configure TextFields
        let defaults = NSUserDefaults.standardUserDefaults()
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text != ""
            }
            textField.placeholder = "Login"
        }
            alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }
        
        // Set Default Info
        let loginTextField = alertController.textFields![0] as UITextField
        if let defaultUsername = defaults.objectForKey("username") as? String {
            loginTextField.text = defaultUsername
            loginAction.enabled = true
        }
        
        // Add Actions
        alertController.addAction(loginAction)
        alertController.addAction(forgotPasswordAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    func errorMessage(title: String, message: String?) {
        var errorAlert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dissmiss")
        errorAlert.show()
    }
    
    func startLoading() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.color = Color.primary1
//        UIView.animateWithDuration(1.0, animations: { () -> Void in
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
//        })
        
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: activityIndicator))
        
        
        activityIndicator.startAnimating()
        
    }
    
    func stopLoading() {

    }
    
    
    
    // MARK: Button Actions
    @IBAction func fundsButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }
    
    @IBAction func donateButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "donate", value: nil)

        CAF.openURL(["http://floridadm.kintera.org/faf/home/default.asp?ievent=1114670"])
    }
    
//    @IBAction func websiteButtonPressed(sender: UIButton) {
//        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "website", value: nil)
//
//        CAF.openURL(["http://www.floridadm.org"])
//    }
//    
//    @IBAction func instagramButtonPressed(sender: UIButton) {
//        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "instagram", value: nil)
//
//        CAF.openURL([
//            "instagram://user?username=DMatUF", // App
//            "https://instagram.com/DMatUF" // Website
//        ])
//    }
//    
//    @IBAction func facebookButtonPressed(sender: UIButton) {
//        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "facebook", value: nil)
//
//        CAF.openURL([
//            "fb://profile/floridaDM", // App
//            "https://www.facebook.com/floridaDM" // Website
//        ])
//    }
//    
//    @IBAction func twitterButtonPressed(sender: UIButton) {
//        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "twitter", value: nil)
//
//        let handle: String = "floridadm"
//        CAF.openURL(["twitter://user?screen_name=\(handle)", // Twitter
//            "tweetbot:///user_profile/\(handle)", // TweetBot
//            "echofon:///user_timeline?\(handle)", // Echofon
//            "twit:///user?screen_name=\(handle)", // Twittelator Pro
//            "x-seesmic://twitter_profile?twitter_screen_name=\(handle)", // Seesmic
//            "x-birdfeed://user?screen_name=\(handle)", // Birdfeed
//            "tweetings:///user?screen_name=\(handle)", // Tweetings
//            "simplytweet:?link=http://twitter.com/\(handle)", // SimplyTweet
//            "icebird://user?screen_name=\(handle)", // IceBird
//            "fluttr://user/\(handle)", // Fluttr
//            "http://twitter.com/\(handle)"])
//    }
//    
//    @IBAction func gameButtonPressed(sender: UIButton) {
//        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "game", value: nil)
//    }
}
