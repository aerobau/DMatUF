//
//  FundraiseViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/30/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class FundraiseViewController: DMMainViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "FundraiseView")

        setText()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.contentOffset = CGPointMake(0,-textView.contentInset.top)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction override func kinteraButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "kinteraButton", value: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dict = defaults.objectForKey("userInfo") as? [String: AnyObject] {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }

    func setText() {
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = NSTextAlignment.Center
        let titleAttributes = [NSForegroundColorAttributeName: Color.primary1, NSFontAttributeName: Font.subheader, NSParagraphStyleAttributeName: titleStyle]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        let paragraphAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: Font.body1, NSParagraphStyleAttributeName: paragraphStyle]

        
        let title1 = NSAttributedString(string: "Register to Fundraise For The Kids!\n", attributes: titleAttributes)
        let paragraph1 = NSAttributedString(string: "\tFundraising through Dance Marathon at UF is a simple way to help out the children being treated at UF Health Shands Children's Hospital, our local Children’s Miracle Network Hospital. It also gives support to their families as they overcome obstacles while their child faces serious illnesses.\n", attributes: paragraphAttributes)
        
        let title2 = NSAttributedString(string: " Register to give back as a Fundraiser in 3 easy steps:\n", attributes: titleAttributes)
        let paragraph2 = NSAttributedString(string: "1. Visit http://floridadm.kintera.org and click 'Participant Registration'.\n2. Either join as an individual, with an organization or start your own team.\n3. Fill out your information to create an account and select 'Fundraiser'.\n\n\tAfter those simple three steps, you will have a personal fundraising page with a unique link you can send to your friends and family via email. You can also promote your page on Facebook and Twitter.\n\n", attributes: paragraphAttributes)

        let paragraph3 = NSAttributedString(string: "\tFriends and family can donate electronically or by checks. All electronic donations are guaranteed to be secure. Please make all check donations out to Children's Miracle Network, and send them to 330C J. Wayne Reitz Union, P.O. Box 118505, Gainesville, FL 32611.", attributes: paragraphAttributes)

        var attributedString = NSMutableAttributedString()
        attributedString.appendAttributedString(title1)
        attributedString.appendAttributedString(paragraph1)
        attributedString.appendAttributedString(title2)
        attributedString.appendAttributedString(paragraph2)
        attributedString.appendAttributedString(paragraph3)

        textView.attributedText = attributedString
    }
}