//
//  KidStoryViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/14/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import CoreData

class KidDetailViewController: UIViewController {
    var kid: Kid?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var milestoneButton: UIButton!
    @IBOutlet weak var milestoneButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var milestoneTopSpace: NSLayoutConstraint!
    @IBOutlet weak var milestoneBottomSpace: NSLayoutConstraint!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "KidsDetailView")

        setInfo()

        view.backgroundColor = Color.tvcEven

        nameLabel.textColor = Color.primary2

        storyView.font = Font.body1
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        storyView.contentOffset.y = 0

        let size = imageView.image?.size ?? CGSizeZero
        imageView.bounds = CGRect(origin: CGPointZero, size: CGSize(width: size.width, height: imageView.frame.height))
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = Color.primary2.CGColor
        imageView.clipsToBounds = true
    }
    
    func setInfo(){
        if let kid = kid {
            nameLabel.text = kid.name ?? "Miracle Child"
            storyView.text = kid.story ?? "No story available"
            imageView.image = UIImage(named: kid.image) ?? UIImage(named: "ImageNotFound")!
            
            if kid.milestone != nil {
                milestoneButton.hidden = false
                let attributedString = NSAttributedString(string: "View \(kid.name)'s Milestone", attributes: [NSForegroundColorAttributeName: Color.primary1, NSFontAttributeName: Font.subheader])
                milestoneButton.setAttributedTitle(attributedString, forState: .Normal)
                milestoneButtonHeight.constant = 22
            } else {
                milestoneButton.hidden = true
                milestoneButtonHeight.constant = 0
            }
        }
    }
    
    @IBAction func milestoneButtonPressed(sender: UIButton) {
        UIApplication.tryURL(["youtube://\(kid!.milestone!)",
            "https://\(kid!.milestone!)"])
    }
    
}