//
//  KidStoryViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/14/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class KidStoryViewController: UIViewController {
    var index: Int? = nil
    var name: String? = nil
    var age: Int? = nil
    var image: UIImage? = nil
    var story: String? = nil
    

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        
        
    }
    
    func setInfo(){
        indexLabel.text = "\(index!)"
        nameLabel.text = name
        ageLabel.text = "\(age)"
        textView.text = story
        
    }
}