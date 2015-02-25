//
//  AboutCells.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/29/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation

class FactsCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.font = Font.subheader
        bottomLabel.font = Font.body1
        
        topLabel.textColor = Color.primary1
        bottomLabel.textColor = UIColor.blackColor()
    }
}

class ContactCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoTextView.tintColor = Color.primary1
        typeLabel?.font = Font.subheader
        infoTextView?.font = Font.body1
    }
}