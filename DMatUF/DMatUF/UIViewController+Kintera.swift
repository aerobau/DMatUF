//
//  UIViewController+Kintera.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/14/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController: UIAlertViewDelegate  {
    struct Properties {
        static var task: NSURLSessionDataTask?
        static var kinteraButtonItem: UIBarButtonItem?
    }
    
    func login(username: String, password: String, success: () -> Void) {
        startLoading()
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "login", value: nil)
        
        let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: "http://dev.floridadm.org/app/kintera.php?username=\(username)&password=\(password)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) ?? NSURL()
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 8.0)
        
        Properties.task = session.dataTaskWithRequest(request) { [unowned self] data, response, error in
            print("DATA \(data)")
            print(NSString(data: data!, encoding: 8))
            print("RESPONSE \(response)")
            print(error)
            
            if NSString(data: data!, encoding: 8) as! String == "Error" {
                Properties.task?.cancel()
                dispatch_async(dispatch_get_main_queue()) {
                    UIAlertView.errorMessage("Login Failed", message: "Invalid username or password.\nTry again.")
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if let dataUnwrapped = data {
                    var rawJSON = try? NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .AllowFragments)
                    
                    if let result = rawJSON as? [String: AnyObject] {
                        print(result)
                        // Save Login info to NSUserDefaults
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(username, forKey: "username")
                        defaults.setObject(password, forKey: "password")
                        defaults.setObject(result, forKey: "userInfo")
                        
                        // Update Components
                        self.stopLoading()
                        GA.sendEvent(category: GA.K.CAT.ACTION, action: GA.K.ACT.LOGIN, label: "login success", value: nil)
                        success()
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
    
    // Handle UIAlerts
    func loginAlert() {
        GA.sendEvent(category: GA.K.CAT.ACTION, action: GA.K.ACT.LOADED, label: "login attempt", value: nil)
        
        if Reachability.connectedToInternet() {
            
            let alertTitle = "Kintera Login"
            let alertMessage = "Enter your username and password:"
            let defaults = NSUserDefaults.standardUserDefaults()
            
            
            print("AlertController exists")
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            
            // Login Button
            let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
                let loginTextField = alertController.textFields![0] 
                let passwordTextField = alertController.textFields![1] 
                
                self.login(loginTextField.text!, password: passwordTextField.text!) {
                    self.performSegueWithIdentifier("FundSegue", sender: self)
                }
            }
            
            
            loginAction.enabled = false
            
            
            // Forgot Button
            let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .Destructive) { (_) in
                UIApplication.tryURL(["http://floridadm.kintera.org/faf/login/loginFindPassword.asp?ievent=1114670&lis=1&kntae1114670=BA9334B40FC64C91BE87CF7E42172BE5"])
            }
            
            // Cancel Button
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { Void in
            }
            
            // Configure TextFields
            
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
            let loginTextField = alertController.textFields![0] 
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
            
            
            
            
        } else {
            UIAlertView.errorMessage("Error", message: "Internet connection required!")
            
        }
        
        
        
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if respondsToSelector("kinteraButtonPressed:") {
            if buttonIndex == 0 {
                print("cancel")
            } else if buttonIndex == 1 {
                self.login(alertView.textFieldAtIndex(0)!.text!, password: alertView.textFieldAtIndex(1)!.text!) {
                    self.performSegueWithIdentifier("FundSegue", sender: self)
                }
            } else if buttonIndex == 2 {
                UIApplication.tryURL(["http://floridadm.kintera.org/faf/login/loginFindPassword.asp?ievent=1114670&lis=1&kntae1114670=BA9334B40FC64C91BE87CF7E42172BE5"])
            }
            
            alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        }
    }
    
    func startLoading() {
        
        Properties.kinteraButtonItem = navigationItem.rightBarButtonItem

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = Color.primary1
        let activityItem = UIBarButtonItem(customView: activityIndicator)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.setRightBarButtonItem(activityItem, animated: true)
        }
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        Properties.task?.cancel()
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.setRightBarButtonItem(Properties.kinteraButtonItem, animated: true)
        }
    }
}
