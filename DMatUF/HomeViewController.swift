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
    var task: NSURLSessionDataTask?
    var kinteraButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Google Analytics
        GA.sendScreenView(name: "HomeViewTest")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopLoading()
        countdownImageView.timer = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set Attributes
        welcomeLabel?.textColor = Color.primary2
        announcementsLabel?.textColor = Color.primary1
        topBar?.backgroundColor = Color.secondary1
        bottomBar?.backgroundColor = Color.secondary1
        kinteraButtonItem = navigationItem.rightBarButtonItem
        announcementsTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if CAF.deviceType == DeviceType.iPhone4s {
            welcomeLabel.text = nil
            welcomeLabel.frame.size.height = 0
        }
    }
}

