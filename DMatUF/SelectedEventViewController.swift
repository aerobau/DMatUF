//
//  SelectedEventViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/16/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class SelectedEventViewController: UIViewController {
    var id: Int? = nil
    
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
    }
    
    func setInfo(){
        self.idLabel.text = "\(id!)"
    }
    
}