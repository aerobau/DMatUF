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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextViewAutoHeight!


    let separator = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        contentView.addSubview(separator)
        separator.backgroundColor = Color.secondary1

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.font = UIFont(name: Font.body2.fontName, size: 12.0)
        textView.font = UIFont(name: Font.body1.fontName, size: 14.0)

        textView.textColor = Color.primary2
        dateLabel.textColor = Color.secondary2
                
//        dateLabel.adjustsFontSizeToFitWidth = true
        
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