//
//  HomeViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate(fromString: "2008-08-15 07:30:00")
        println(date)
        println(NSDate())
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let s = formatter.stringFromDate(date)
        println(s)
        
        
    }
    
    @IBAction func loginButtonPressed(sender: UIBarButtonItem) {
        openURL(["https://www.kintera.org/faf/login/loginParticipant.asp?login=lmenu&ievent=1114670"])
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
