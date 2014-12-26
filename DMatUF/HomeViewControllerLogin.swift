//
//  HomeViewController_Login.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UIAlertViewDelegate {
    
    
    @IBAction func fundsButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }

    func login(username: String, password: String) {
        startLoading()
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "login", value: nil)
        
        if let url = NSURL(string: "http://mickmaccallum.com/ian/kintera.php?username=\(username)&password=\(password)") {
            
            let session = NSURLSession.sharedSession()
            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            let loginTask = session.dataTaskWithRequest(request) { [unowned self] data, response, error in
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
            
            loginTask.resume()
            
            
        } else {
            self.stopLoading()
        }
    }
    
    // Handle UIAlerts
    func loginAlert() {
        let alertTitle = "Kintera Login"
        let alertMessage = "Enter your username and password:"
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if CAF.version < 8.0 {
            println("AlertController doesn't exists")
            
            let alertView = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Login", "Forgot Password")
            alertView.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
            
            if let defaultUsername = defaults.objectForKey("username") as? String {
                alertView.textFieldAtIndex(0)?.text = defaultUsername
            }
            alertView.show()
            
        } else {
            println("AlertController exists")
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            
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
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            println("cancel")
        } else if buttonIndex == 1 {
            self.login(alertView.textFieldAtIndex(0)!.text, password: alertView.textFieldAtIndex(1)!.text)
        } else if buttonIndex == 2 {
            CAF.openURL(["http://floridadm.kintera.org/faf/login/loginFindPassword.asp?ievent=1114670&lis=1&kntae1114670=BA9334B40FC64C91BE87CF7E42172BE5"])
        }
        
        alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        
    }
    
    func errorMessage(title: String, message: String?) {
        var errorAlert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dissmiss")
        errorAlert.show()
    }
    
    func startLoading() {
    }
    
    func stopLoading() {
    }
}

