//
//  AnnouncementCell.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/22/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class AnnouncementCell: UITableViewCell {
    @IBOutlet weak var balloonImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    let separator = UIView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentView.addSubview(separator)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: Font.body1.fontName, size: 16.0)
        dateLabel.font = UIFont(name: Font.body2.fontName, size: 12.0)
        
        titleLabel.textColor = Color.primary2
        dateLabel.textColor = Color.secondary2
        
        if UIDevice.version < 8.0 {
            titleLabel.numberOfLines = 1
            titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        } else {
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        }
        
        dateLabel.adjustsFontSizeToFitWidth = true        
        separator.backgroundColor = Color.secondary1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        separator.frame = CGRectMake(0, frame.height - 2.0, frame.width, 2.0)
    }

    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        balloonImageView.image = balloonImageView.image?.imageWithColor(Color.primary2)
    }
}