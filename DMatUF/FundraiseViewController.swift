//
//  FundraiseViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/30/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class FundraiseViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var task: NSURLSessionDataTask?
    var kinteraButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setText()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.contentOffset = CGPointMake(0,-textView.contentInset.top)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopLoading()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kinteraButtonItem = navigationItem.rightBarButtonItem
    }
    
    @IBAction func kinteraButtonPressed(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }

    func setText() {
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = NSTextAlignment.Center
        let titleAttributes = [NSForegroundColorAttributeName: Color.primary1, NSFontAttributeName: Font.subheader, NSParagraphStyleAttributeName: titleStyle]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        let paragraphAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: Font.body1, NSParagraphStyleAttributeName: paragraphStyle]

        
        let title1 = NSAttributedString(string: "Register to Fundraise For The Kids!\n", attributes: titleAttributes)
        let paragraph1 = NSAttributedString(string: "\tFundraising through Dance Marathon at UF is a simple way to help out the children being treated at UF Health Shands Children's Hospital, our local Children’s Miracle Network Hospital. It also gives support to their families as they overcome obstacles while their child faces serious illnesses.\n", attributes: paragraphAttributes)
        
        let title2 = NSAttributedString(string: " Register to give back as a Fundraiser in 3 easy steps:\n", attributes: titleAttributes)
        let paragraph2 = NSAttributedString(string: "1. Visit http://floridadm.kintera.org and click 'Participant Registration'.\n2. Either join as an individual, with an organization or start your own team.\n3. Fill out your information to create an account and select 'Fundraiser'.\n\n\tAfter those simple three steps, you will have a personal fundraising page with a unique link you can send to your friends and family via email. You can also promote your page on Facebook and Twitter.\n\n", attributes: paragraphAttributes)

        let paragraph3 = NSAttributedString(string: "\tFriends and family can donate electronically or by checks. All electronic donations are guaranteed to be secure. Please make all check donations out to Children's Miracle Network, and send them to 330C J. Wayne Reitz Union, P.O. Box 118505, Gainesville, FL 32611.", attributes: paragraphAttributes)

        var attributedString = NSMutableAttributedString()
        attributedString.appendAttributedString(title1)
        attributedString.appendAttributedString(paragraph1)
        attributedString.appendAttributedString(title2)
        attributedString.appendAttributedString(paragraph2)
        attributedString.appendAttributedString(paragraph3)

        textView.attributedText = attributedString
    }
    
    
    
    @IBAction func donateButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "donate", value: nil)
        
        CAF.openURL(["http://floridadm.kintera.org/faf/home/default.asp?ievent=1114670"])
    }
}

extension FundraiseViewController: UIAlertViewDelegate {
    func login(username: String, password: String) {
        startLoading()
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "login", value: nil)
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://mickmaccallum.com/ian/kintera.php?username=\(username)&password=\(password)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) ?? NSURL()
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
                    CAF.errorMessage("Error \(error.code)", message: "\(error.localizedDescription)")
                }
            }
        }
        task?.resume()
    }
    
    // Handle UIAlerts
    func loginAlert() {
        if Reachability.connectedToInternet() {
            
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
            
            
            
        } else {
            CAF.errorMessage("Error", message: "Internet connection required!")
            
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
    
    func startLoading() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = Color.primary1
        let activityItem = UIBarButtonItem(customView: activityIndicator)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.setRightBarButtonItem(activityItem, animated: true)
        }
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        task?.cancel()
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.setRightBarButtonItem(self.kinteraButtonItem, animated: true)
        }
    }
}