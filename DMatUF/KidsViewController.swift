//
//  KidsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/25/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

//
//  KidsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/13/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import Foundation

class KidsViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Get array of kids from plist file
    var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Kids", ofType: "plist")!)!
    var namesArray: Array<String> = []
    var thumbsArray: Array<String> = []
    var task: NSURLSessionDataTask?
    var kinteraButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.tvcEven
        generateArrays()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopLoading()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kinteraButtonItem = navigationItem.rightBarButtonItem
    }
    
    func generateArrays() {
    
        for dict in array{
            if let name: String? = dict["name"] as String?{
                self.namesArray.append(name!)
            }
            if let thumb: String? = dict["image"] as String?{
                self.thumbsArray.append(thumb!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    @IBAction func kinteraButtonPressed(sender: UIBarButtonItem) {
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
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KidCellID", forIndexPath: indexPath) as KidsCell
            
            // Set cell background color
            cell.backgroundColor = UIColor.clearColor()
            

            
            cell.cellLabel.text = self.namesArray[indexPath.row]
            cell.cellLabel.adjustsFontSizeToFitWidth = true
            
            cell.cellImage.image = UIImage(named: self.thumbsArray[indexPath.row]) ?? UIImage(named: "ImageNotFound")
        
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var size = CGFloat(96.0)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                size = (view.frame.width - 12.0) / 3.0
            }
            
            return CGSize(width: size, height: size)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "KidDetailSegue") {
            let destination = segue.destinationViewController as KidDetailViewController

            if let indexPath = collectionView?.indexPathForCell(sender as KidsCell) {
                if let dict = array.objectAtIndex(indexPath.row) as? Dictionary<String, AnyObject> {
                    destination.kid = Kid(dict: dict)
                }
            }
        }
    }
}

extension KidsViewController: UIAlertViewDelegate {
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