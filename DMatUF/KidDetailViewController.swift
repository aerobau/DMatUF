//
//  KidStoryViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/14/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

// Kid Class: so attributes can be easily accessed
class Kid {
    var name: String?
    var age: NSDate?
    var story: String?
    var imageName: String?
    
    convenience init(dict: Dictionary<String, AnyObject>) {
        self.init()
        name = Optional(dict["name"]! as? String)!
        age = Optional(dict["age"]! as? NSDate)!
        story = Optional(dict["story"]! as? String)!
        imageName = Optional(dict["image"]! as? String)!
        
    }
}

class KidDetailViewController: UIViewController {
    var kid: Kid?
    

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
        if let kid = kid {
            nameLabel.text = kid.name ?? "No name available"
            textView.text = kid.story ?? "No story available"
            ageLabel.text = calculateAge(kid.age) ?? "No age available"

            if let imageName = kid.imageName {
                if let image = UIImage(named: imageName) ?? UIImage(named: "ImageNotFound")! {
                    imageView.image = image
                }
            }
        }
        
        

        
    }
    
    func calculateAge (birthday: NSDate?) -> String? {
        if let bday = birthday {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yy"
            let age = formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: bday.timeIntervalSinceNow))
            return age

        } else {
        return nil
        }
    }
}