//
//  EventCell.swift
//  DM
//
//  Created by Ian MacCallum on 10/23/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var calendarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: Font.body1.fontName, size: 16.0)
        timeLabel.font = UIFont(name: Font.body2.fontName, size: 12.0)
        
        if UIDevice.version < 8.0 {
            titleLabel.numberOfLines = 1
            titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        } else {
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        }
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        calendarImageView.layer.cornerRadius = 8.0
        calendarImageView.layer.masksToBounds = true
    }
}
