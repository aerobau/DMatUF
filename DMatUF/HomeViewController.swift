//
//  HomeViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/5/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController  {
    
    @IBOutlet weak var countdownImageView: CountdownImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var announcementsLabel: UILabel!
    @IBOutlet weak var announcementsTableView: AnnouncementsTableView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // Set Attributes
        welcomeLabel.textColor = Color.primary2
        announcementsLabel.textColor = Color.primary1
        topBar.backgroundColor = Color.secondary1
        bottomBar.backgroundColor = Color.secondary1
        
        announcementsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Google Analytics
        GA.sendScreenView(name: "HomeViewTest")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    

}

