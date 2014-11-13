//
//  KinteraAccountViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/12/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

//
//  KinteraLogin.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/29/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class KinteraAccountViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
}