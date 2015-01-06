//
//  KidCell.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/22/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import Foundation

class KidsCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        
        cellLabel.font = Font.accent
        cellLabel.textColor = Color.primary2
        cellImage.layer.borderColor = Color.primary1.CGColor

    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        cellImage.layer.cornerRadius = cellImage.frame.width / 2.0
        cellImage.layer.masksToBounds = true
        
        cellImage.layer.borderWidth = 2.0
    }
    
    
}