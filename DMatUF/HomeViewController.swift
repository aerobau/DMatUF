//
//  HomeViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class test: UICollectionViewCell {
    
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate, UIScrollViewDelegate {
    
    // Create Outles
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homePageControl: UIPageControl!
    
    var loginTask: NSURLSessionDataTask?
    
    // Create Variables
    var loggedIn: Bool = false
    var loadingAlert: UIAlertView?

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        homeCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingAlert()
    }
    
    // Handle UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCellID", forIndexPath: indexPath) as HomeCell
            return cell
        } else {
                        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FundCellID", forIndexPath: indexPath) as FundCell
            cell.layoutSubviews()
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()

        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            loggedIn = true
            loginBarButton.title = "Logout"
            homePageControl.numberOfPages = 2
            return 2
        } else {
            loggedIn = false
            loginBarButton.title = "Login"
            homePageControl.numberOfPages = 1
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: homeCollectionView.bounds.size.width -
                homeCollectionView.contentInset.left -
                homeCollectionView.contentInset.right,
                height: homeCollectionView.bounds.size.height -
                    homeCollectionView.contentInset.top -
                    homeCollectionView.contentInset.bottom)
    }
    
    // Handle UIScrollView and UIPageControl
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetCenter = CGPoint(x: scrollView.contentOffset.x - scrollView.contentInset.left + scrollView.center.x,
            y: scrollView.center.y)
        if let row = self.homeCollectionView.indexPathForItemAtPoint(offsetCenter)?.item {
            homePageControl.currentPage = row
        }
    }
    
    func scrollToFunds() {
        let offset = homeCollectionView.frame.size.width * CGFloat(1)
        let scrollTo = CGPointMake(offset, 0)
        homeCollectionView.setContentOffset(scrollTo, animated: true)
    }
    
    @IBAction func pageControlChanged(sender: UIPageControl) {
        let pc = sender
        let offset = homeCollectionView.frame.size.width * CGFloat(pc.currentPage)
        let scrollTo = CGPointMake(offset, 0)
        homeCollectionView.setContentOffset(scrollTo, animated: true)
    }
    
    
    func login(username: String, password: String) {
        startLoading()
        
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
                            self.homeCollectionView.reloadData()
                            self.stopLoading()
                            self.scrollToFunds()
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
    
    
    func logout() {
        let offset = homeCollectionView.frame.size.width * CGFloat(0)
        let scrollTo = CGPointMake(offset, 0)
        homeCollectionView.setContentOffset(scrollTo, animated: true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "username")
        defaults.setObject(nil, forKey: "password")
        defaults.setObject(nil, forKey: "userInfo")
        
        loggedIn = false
        
        delay(0.25, closure: {
            self.homeCollectionView.reloadData()
        })
    }
    
    
    
    // Handle UIAlerts
    func loginAlert() {
        
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        // Login Button
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
            
            self.login(loginTextField.text, password: passwordTextField.text)
        }
        loginAction.enabled = false
        
        // Forgot Button
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .Destructive) { (_) in
            self.openURL(["http://floridadm.kintera.org/faf/login/loginFindPassword.asp?ievent=1114670&lis=1&kntae1114670=BA9334B40FC64C91BE87CF7E42172BE5"])
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
            let passwordTextField = alertController.textFields![1] as UITextField
            if let defaultPassword = defaults.objectForKey("password") as? String {
                passwordTextField.text = defaultPassword
                loginAction.enabled = true
            }
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
        loadingAlert?.show()
    }
    
    func stopLoading() {
        loadingAlert?.dismissWithClickedButtonIndex(0, animated: false)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == loadingAlert {
            if buttonIndex == 0 {
                loginTask?.cancel()
                stopLoading()
            }
        }
    }
    
    
    // Handle UIButtons
    @IBAction func loginButtonPressed(sender: UIBarButtonItem) {
        if loggedIn {
            logout()
        } else {
            if Reachability.isConnectedToNetwork() {
                loginAlert()
            } else {
                errorMessage("No Internet Connection!", message: nil)
            }
        }
    }
    
    @IBAction func donateButtonPressed(sender: UIBarButtonItem) {
        openURL(["http://floridadm.kintera.org/faf/home/default.asp?ievent=1114670"])
    }
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        openURL(["http://www.floridadm.org"])
    }
    
    @IBAction func instagramButtonPressed(sender: UIButton) {
        openURL([
            "instagram://user?username=DMatUF", // App
            "https://instagram.com/DMatUF" // Website
        ])
    }
    
    @IBAction func facebookButtonPressed(sender: UIButton) {
        openURL([
            "fb://profile/floridaDM", // App
            "https://www.facebook.com/floridaDM" // Website
        ])
    }
    
    @IBAction func twitterButtonPressed(sender: UIButton) {
        let handle: String = "floridadm"
        openURL(["twitter://user?screen_name=\(handle)", // Twitter
            "tweetbot:///user_profile/\(handle)", // TweetBot
            "echofon:///user_timeline?\(handle)", // Echofon
            "twit:///user?screen_name=\(handle)", // Twittelator Pro
            "x-seesmic://twitter_profile?twitter_screen_name=\(handle)", // Seesmic
            "x-birdfeed://user?screen_name=\(handle)", // Birdfeed
            "tweetings:///user?screen_name=\(handle)", // Tweetings
            "simplytweet:?link=http://twitter.com/\(handle)", // SimplyTweet
            "icebird://user?screen_name=\(handle)", // IceBird
            "fluttr://user/\(handle)", // Fluttr
            "http://twitter.com/\(handle)"])
    }
    
    @IBAction func gameButtonPressed(sender: UIButton) {
        
    }
    
    
    
    // Handle Links
    func openURL(dict: [String]) {
        let application: UIApplication = UIApplication.sharedApplication()
        for url in dict {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
    
    // Other
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func setupLoadingAlert() {
        loadingAlert  = UIAlertView(title: "Loading...", message: nil, delegate: self, cancelButtonTitle: "Cancel")
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        loadingAlert?.setValue(indicator, forKey: "accessoryView")
        indicator.startAnimating()
    }
    

}
