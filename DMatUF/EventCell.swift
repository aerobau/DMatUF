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
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
}
