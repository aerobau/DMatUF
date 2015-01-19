//
//  PlayViewController.swift
//  DanceMarathonGame
//
//  Created by Ian MacCallum on 1/15/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
//    var game = GameData(mode: 0, categories: [0,1,2])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: "tapGesture")
        view.addGestureRecognizer(tap)
        
        if UIDevice.currentDevice().orientation.isLandscape == true {
            println("DEVICE IN LANDSCAPE")
            beginCountDown()
            
        } else {
            println("DEVICE IN PORTRAIT")
            textLabel.text = "Hold the device to your forehead"
        }        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func orientationChanged(sender: NSNotification) {
        println("ORIENTATION CHANGED")
        println(sender.name)
        if UIDevice.currentDevice().orientation.isLandscape == true {
            println("DEVICE IN LANDSCAPE")
            
        } else {
            println("DEVICE IN PORTRAIT")
            textLabel.text = "Hold the device to your forehead"
        }

    }
    
    func tapGesture() {
        println("TAP")
    }

    func beginCountDown() {
        println("MAKE SURE YOU'RE IN LANDSCAPE")
    }

    func gameStateChanged() {
        println("GAME STATE CHANGED")
    }
    
}