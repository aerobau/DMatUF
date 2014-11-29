//
//  UniTheme.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/10/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class UniversalTheme {
    func setupTheme(primary primaryColor: UIColor, secondary secondaryColor: UIColor, font fontName: NSString, statusBarLight lightStatusBar: Bool) {
        if (lightStatusBar) {
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        }
    
//        customizeNavBarButton(color: primaryColor)
        customizeTabBar(color: secondaryColor)
//        customizeSwitch(color: primaryColor)
//        customizeSearchBar(bar: primaryColor, tint: secondaryColor)
        customizeActivityIndicator(color: primaryColor)
//        customizeButton(color: primaryColor)
        customizePageControl(color: primaryColor)
//        customizeSegmentControl(main: primaryColor, secondary: secondaryColor)
//        customizeSlider(color: primaryColor)
    }
    
    
    
    // UIBarButtonItem
    func customizeNavBarButton(color buttonColor: UIColor) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: buttonColor], forState: UIControlState.Normal)
    }
    
    // UITabBar
    func customizeTabBar(color selectedColor: UIColor) {
        UITabBar.appearance().tintColor = selectedColor
    }
    

    
    // UIButton
    func customizeButton(color buttonColor: UIColor) {
        UIButton.appearance().setTitleColor(buttonColor, forState: UIControlState.Normal)
    }

    // UISwitch
    func customizeSwitch(color switchColor: UIColor) {
        UISwitch.appearance().onTintColor = switchColor
    }

    // UISearchBar
    func customizeSearchBar(bar barColor: UIColor, tint tintColor: UIColor) {
        UISearchBar.appearance().barTintColor = barColor
        UISearchBar.appearance().tintColor = tintColor
    }

    // UIActivityIndicator
    func customizeActivityIndicator(color activityColor: UIColor) {
        UIActivityIndicatorView.appearance().color = activityColor
    }
    
    // UISegmentedControl
    func customizeSegmentControl(main mainColor: UIColor, secondary secondaryColor: UIColor) {
        UISegmentedControl.appearance().tintColor = mainColor
    }
    
    // UISlider
    func customizeSlider(color sliderColor: UIColor) {
        UISlider.appearance().minimumTrackTintColor = sliderColor
    }
    
    // UIToolbar
    func customizeToolbar(color toolbarColor: UIColor) {
        UIToolbar.appearance().tintColor = toolbarColor
    }
    
    // UIPageControl
    func customizePageControl(color mainColor: UIColor) {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGrayColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = mainColor
        UIPageControl.appearance().backgroundColor = UIColor.clearColor()
    }



    
}