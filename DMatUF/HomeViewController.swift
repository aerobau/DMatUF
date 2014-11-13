//
//  HomeViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
}

class FundCell: UICollectionViewCell {
    
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate {
    
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homePageControl: UIPageControl!
    var loggedIn: Bool = false
    var loadingAlert = UIAlertView(title: "Loading...", message: nil, delegate: nil, cancelButtonTitle: "Cancel")

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        homeCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingAlert()
        
//        let date = NSDate(fromString: "2008-08-15 07:30:00")
//        println(date)
//        println(NSDate())
//        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        let s = formatter.stringFromDate(date)
//        println(s)
        
        
    }
    
    func setupLoadingAlert() {
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        loadingAlert.setValue(indicator, forKey: "accessoryView")
        indicator.startAnimating()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCellID", forIndexPath: indexPath) as HomeCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FundCellID", forIndexPath: indexPath) as FundCell
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
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetCenter = CGPoint(x: targetContentOffset.memory.x - scrollView.contentInset.left + scrollView.center.x,
            y: scrollView.center.y)
        
        if let row = self.homeCollectionView.indexPathForItemAtPoint(offsetCenter)?.item {
            homePageControl.currentPage = row
        }
    }

    @IBAction func pageControlChanged(sender: UIPageControl) {
        let pc = sender
        let offset = homeCollectionView.frame.size.width * CGFloat(pc.currentPage)
        let scrollTo = CGPointMake(offset, 0)
        homeCollectionView.setContentOffset(scrollTo, animated: true)
    }
    
    func scrollToFunds() {
        let offset = homeCollectionView.frame.size.width * CGFloat(1)
        let scrollTo = CGPointMake(offset, 0)
        homeCollectionView.setContentOffset(scrollTo, animated: true)
    }
    
  
    
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
    
    func login(username: String, password: String) {
        startLoading()
        let session = NSURLSession.sharedSession()
        
        if let url = NSURL(string: "http://mickmaccallum.com/ian/kintera.php?&username=\(username)&password=\(password)") {
            
            var request = NSMutableURLRequest(URL: url)
            let queue: NSOperationQueue = NSOperationQueue.mainQueue()
            
            if let connection = NSURLConnection(request: request, delegate: self, startImmediately: true) {
                
                NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData?, error: NSError!) in
                    
                    if let dataUnwrapped = data {
                        var rawJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .allZeros, error: nil)
                        
                        if let result = rawJSON as? [String: AnyObject] {
                            
                            // Save Login info to NSUserDefaults
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(username, forKey: "username")
                            defaults.setObject(password, forKey: "password")
                            defaults.setObject(result, forKey: "userInfo")
                            self.homeCollectionView.reloadData()
                            self.stopLoading()
                            self.scrollToFunds()
                        } else {
                            self.stopLoading()
                            self.errorMessage("Invalid Login!", message: nil)
                        }
                    } else {
                        self.stopLoading()
                        self.errorMessage("No Internet Connection!", message: nil)
                    }
                })
            } else {
                self.stopLoading()
                errorMessage("Connection Failed!", message: nil)
            }
        } else {
            self.stopLoading()
            errorMessage("Invalid URL!", message: nil)
        }
    }
    
    func errorMessage(title: String, message: String?) {
        var errorAlert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dissmiss")
        errorAlert.show()
    }
    
    func logout() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "username")
        defaults.setObject(nil, forKey: "password")
        defaults.setObject(nil, forKey: "userInfo")
        
        let offset = homeCollectionView.frame.size.width * CGFloat(0)
        let scrollTo = CGPointMake(offset, 0)
        homeCollectionView.setContentOffset(scrollTo, animated: true)
        loggedIn = false
        self.homeCollectionView.reloadData()
    }
    
    func startLoading() {
        loadingAlert.show()
    }
    
    func stopLoading() {
        loadingAlert.dismissWithClickedButtonIndex(0, animated: false)
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
    
    @IBAction func loginButtonPressed(sender: UIBarButtonItem) {
        if loggedIn {
            logout()
        } else {
            loginAlert()
        }
    }
    
    func openURL(dict: [String]) {
        
        let application: UIApplication = UIApplication.sharedApplication()
        
        for url in dict {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
