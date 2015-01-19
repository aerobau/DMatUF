//
//  DonateBarButtonItem.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/7/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class DonateBarButtonItem: UIBarButtonItem {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Donate"
        target = self
        action = "donateButtonPressed:"
    }
    
    func donateButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "donate", value: nil)
        
        CAF.openURL(["http://floridadm.kintera.org/faf/search/searchParticipants.asp?ievent=1114670&lis=1&kntae1114670=15F87DA40F9142E489120152BF028EB2"])
    }
}


