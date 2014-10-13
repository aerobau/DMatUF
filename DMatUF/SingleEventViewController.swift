//
//  SingleEventViewController.swift
//  DMatUF
//
//  Created by Mick on 10/13/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class SingleEventViewController: UIViewController {
    var event: Event? {
        didSet {
            title = event?.name
        }
    }
}