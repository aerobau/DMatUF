//
//  DMMainViewController.swift
//  SlideOutTest2
//
//  Created by Alexander Robau on 9/29/15.
//  Copyright © 2015 Alexander Robau. All rights reserved.
//

import UIKit

// Protocol to define the required methods that must be implemented by the container and will be
// called from the main view controller in order to show the panel as necessary if the user presses
// the panel button
protocol DMMainDelegate {
    // Function to toggle the panel from in to out
    
    func togglePanel()
}

class DMMainViewController: UIViewController {
    
    var mainDelegate: DMMainDelegate?

    @IBAction func kinteraButtonPressed(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
        mainDelegate?.togglePanel()
    }
}


