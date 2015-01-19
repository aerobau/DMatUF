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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playButtonPressed(sender: UIButton) {

        performSegueWithIdentifier("PlaySegue", sender: self)
        
    }
    @IBAction func categoriesButtonPressed(sender: UIButton) {
    }
    @IBAction func gameModesButtonPressed(sender: UIButton) {
    }
    @IBAction func howToPlayButtonPressed(sender: UIButton) {
    }
}

