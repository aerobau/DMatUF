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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
    }
    
    func setInfo(){
        if let kid = kid {
            nameLabel.text = kid.name ?? "No name available"
            textView.text = kid.story ?? "No story available"
            imageView.image = UIImage(named: kid.imageName!) ?? UIImage(named: "ImageNotFound")!
        }
        textView.editable = false
        textView.selectable = false
    }
}