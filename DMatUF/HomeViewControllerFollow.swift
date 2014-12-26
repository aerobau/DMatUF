//
//  HomeViewController_IBActions.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UIActionSheetDelegate {
    
    
    
    @IBAction func followButtonPressed(sender: UIBarButtonItem) {
        let actionSheet = UIActionSheet(title: "Follow Us!", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Facebook", "Instagram", "Twitter", "YouTube")
        actionSheet.showInView(view)
    }

    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            break
        case 1:
            facebookButtonPressed()
            break
        case 2:
            instagramButtonPressed()
            break
        case 3:
            twitterButtonPressed()
            break
        case 4:
            youtubeButtonPressed()
            break
        default:
            break
        }
        println("Dismiss: \(buttonIndex)")
        actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
    }
    

    func facebookButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "facebook", value: nil)
        
        CAF.openURL([
            "fb://profile/floridaDM", // App
            "https://www.facebook.com/floridaDM" // Website
            ])
    }
    
    func instagramButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "instagram", value: nil)
        
        CAF.openURL([
            "instagram://user?username=DMatUF", // App
            "https://instagram.com/DMatUF" // Website
            ])
    }
    
    func twitterButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "twitter", value: nil)
        
        let handle: String = "floridadm"
        CAF.openURL(["twitter://user?screen_name=\(handle)", // Twitter
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
    
    func youtubeButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "youtube", value: nil)
        
        CAF.openURL([
            "youtube://www.youtube.com/user/UFDanceMarathon", // App
            "https://www.youtube.com/user/UFDanceMarathon" // Website
            ])
    }
    

    

    
   
    func donateButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "donate", value: nil)
        
        CAF.openURL(["http://floridadm.kintera.org/faf/home/default.asp?ievent=1114670"])
    }
    
    func websiteButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "website", value: nil)
        
        CAF.openURL(["http://www.floridadm.org"])
    }
    
    
    func gameButtonPressed() {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "game", value: nil)
    }
}
