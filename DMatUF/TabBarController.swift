//
//  TabBarController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/16/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if let order = defaults.objectForKey("tabOrder") as? [AnyObject]{
            var vcArray: Array<UIViewController>
            for id in order{
//                vcArray.append(vc)
            }
//            self.viewControllers = vcArray
            println(order)
        }

        delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(tabBar: UITabBar, didEndCustomizingItems items: [AnyObject], changed: Bool) {
        var tabsArray: Array<String> = Array()
        
        println(self.viewControllers?.count)

        if let vcArray = self.viewControllers as? [UIViewController]{
            for vc in vcArray {
                if let id = vc.restorationIdentifier{
                    tabsArray.append(id)
                }
            }
        }
        println(tabsArray)
        NSUserDefaults.standardUserDefaults().setObject(tabsArray, forKey: "tabOrder")

    }
}
