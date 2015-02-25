//
//  ViewController.swift
//  DanceMarathonGame
//
//  Created by Ian MacCallum on 1/14/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func playButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("GameSegue", sender: nil)
    }
}

