//
//  ViewController.swift
//  DanceMarathonGame
//
//  Created by Ian MacCallum on 1/14/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var playButton: GameButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.font = Font.body1
        descriptionTextView.bounces = false
        descriptionTextView.editable = false
        descriptionTextView.selectable = false
        
        let text = "\tStand Up FTK is an interactive game that can be played with two or more people. Learn a little Dance Marathon at UF trivia with your friends as you try to act out the word on the screen! Play against your friends and see who knows more about this year's Theme Hours and Event!"
        
        let note = "\n" + "\n" + "Note: Swipe down to close the game" + "\n"
        
        let leftStyle = NSMutableParagraphStyle()
        leftStyle.alignment = NSTextAlignment.Left
        let centerStyle = NSMutableParagraphStyle()
        centerStyle.alignment = NSTextAlignment.Center
        
        let image = UIImage(named: "SwipeDown")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        let attrImage = NSMutableAttributedString(attributedString: imageString)
        
        let noteString = NSMutableAttributedString(string: note, attributes: nil)
        noteString.appendAttributedString(attrImage)
        noteString.addAttribute(NSParagraphStyleAttributeName, value: centerStyle, range: NSMakeRange(0, noteString.length))

        let attrString = NSMutableAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: leftStyle])
        
        attrString.appendAttributedString(noteString)
        attrString.addAttribute(NSFontAttributeName, value: Font.body1.fontWithSize(18.0), range: NSMakeRange(0, attrString.length))
        descriptionTextView.attributedText = attrString

    }
    
    @IBAction func playButtonPressed(sender: GameButton) {
        performSegueWithIdentifier("GameSegue", sender: nil)
    }
}

class GameButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(frame: CGRect, url: String) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        setAttributedTitle(NSAttributedString(string: self.titleLabel?.text ?? "", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Font.accent.fontName, size: 20.0)!]), forState: UIControlState.Normal)

        contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        
        layer.borderColor = Color.tvcSeparator.CGColor
        layer.borderWidth = 2.0
        
        setBackgroundImage(backgroundImage(), forState: UIControlState.Normal)
        setBackgroundImage(pressedImage(), forState: UIControlState.Highlighted)
        setBackgroundImage(pressedImage(), forState: UIControlState.Selected)
        
        
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func backgroundImage() -> UIImage? {
        
        var image: UIImage?
        
        let grad = CAGradientLayer()
        grad.frame = bounds
        grad.colors = [Color.primary1.CGColor, Color.secondary1.CGColor]
        grad.locations = [0.0, 1.0]
        grad.startPoint = CGPointMake(0.5, 0)
        grad.endPoint = CGPointMake(0.5, 1.0)
        
        UIGraphicsBeginImageContext(grad.bounds.size);
        grad.renderInContext(UIGraphicsGetCurrentContext())
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    func pressedImage() -> UIImage? {
        
        var image: UIImage?
        
        let grad = CAGradientLayer()
        grad.frame = bounds
        grad.colors = [Color.primary1.CGColor, Color.secondary1.CGColor]
        grad.locations = [0.0, 1.0]
        grad.startPoint = CGPointMake(0.5, 0)
        grad.endPoint = CGPointMake(0.5, 1.0)
        
        let overlay = CALayer()
        overlay.frame = bounds
        overlay.backgroundColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        
        UIGraphicsBeginImageContext(grad.bounds.size);
        grad.renderInContext(UIGraphicsGetCurrentContext())
        overlay.renderInContext(UIGraphicsGetCurrentContext())
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
}
