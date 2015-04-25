//
//  GameWebViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/19/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class GameWebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
    
        let request = NSURLRequest(URL: NSURL(string: "http://104.236.1.77/Stand/game.html")!)
        webView.loadRequest(request)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        swipeGesture.direction = .Down
        webView.addGestureRecognizer(swipeGesture)
        
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        dismissViewControllerAnimated(true) {
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}