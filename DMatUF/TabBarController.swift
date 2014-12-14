//
//  TabBarController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/7/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, UITabBarDelegate, UINavigationControllerDelegate, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizableViewControllers = nil
    
        view.tintColor = UIColor.redColor()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
//        if let tabItems = tabBar.items as? [UITabBarItem] {
//            for item in tabItems {
//                item.image = item.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//                
//                item.selectedImage = item.selectedImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//            }
//        }
    }
}
