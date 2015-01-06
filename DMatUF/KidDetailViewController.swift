//
//  KidStoryViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/14/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class KidDetailViewController: UIViewController {
    var kid: Kid?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.tvcEven

        storyView.font = Font.body1
        setInfo()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationItem.leftBarButtonItem?.title = "Back"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let size = imageView.image?.size ?? CGSizeZero
        imageView.bounds = CGRect(origin: CGPointZero, size: CGSize(width: size.width, height: imageView.frame.height))
        
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = Color.primary2.CGColor
        
        imageView.clipsToBounds = true

    }
    
    func setInfo(){
        
        if let kid = kid {
            navigationItem.title = kid.name ?? "Miracle Child"
            storyView.text = kid.story ?? "No story available"
            imageView.image = UIImage(named: kid.imageName ?? "ImageNotFound") ?? UIImage(named: "ImageNotFound")!
        }
    }
    
    @IBAction func donateButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "donate", value: nil)
        
        CAF.openURL(["http://floridadm.kintera.org/faf/home/default.asp?ievent=1114670"])
    }
}