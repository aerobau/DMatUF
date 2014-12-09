//
//  IMTheme.swift
//  IMThemeDemo
//
//  Created by Ian MacCallum on 11/10/14.
//

import UIKit

class IMTheme {
    func setupTheme(#primary: UIColor, secondary: UIColor) {
    
        // Comment out and customize colors here
//        customizeLabel(color: primary)
        customizeNavBar(color: secondary)
        customizeTabBar(color: secondary)
//        customizeSwitch(color: secondary)
//        customizeSearchBar(bar: primary, tint: secondary)
        customizeActivityIndicator(color: primary)
//        customizeButton(color: primary)
        customizeSegmentControl(primary: primary, secondary: secondary)
//        customizeSlider(primary: primary, secondary: secondary)
        customizePageControl(primary: primary, secondary: secondary)
//        customizeStepper(color: primary)
        customizeProgressView(primary: primary, secondary: secondary)
    }
    
    // UILabel
    func customizeLabel(#color: UIColor) {
        UILabel.appearance().textColor = color
    }
    
    // UIBarButtonItem
    func customizeNavBar(#color: UIColor) {
        UINavigationBar.appearance().tintColor = color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: color]
    }
    
    // UITabBar
    func customizeTabBar(#color: UIColor) {
        UITabBar.appearance().tintColor = color
    }
    
    // UIButton
    func customizeButton(#color: UIColor) {
        UIButton.appearance().setTitleColor(color, forState: UIControlState.Normal)
    }

    // UISwitch
    func customizeSwitch(#color: UIColor) {
        UISwitch.appearance().onTintColor = color
        //UISwitch.appearance().thumbTintColor = UIColor.lightGrayColor()
    }

    // UISearchBar
    func customizeSearchBar(#bar: UIColor, tint: UIColor) {
        UISearchBar.appearance().barTintColor = bar
        UISearchBar.appearance().tintColor = tint
    }

    // UIActivityIndicator
    func customizeActivityIndicator(#color: UIColor) {
        UIActivityIndicatorView.appearance().color = color
    }
    
    // UISegmentedControl
    func customizeSegmentControl(#primary: UIColor, secondary: UIColor) {
        UISegmentedControl.appearance().tintColor = primary
    }
    
    // UISlider
    func customizeSlider(#primary: UIColor, secondary: UIColor) {
        UISlider.appearance().minimumTrackTintColor = primary
    }
    
    // UIPageControl
    func customizePageControl(#primary: UIColor, secondary: UIColor) {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGrayColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = primary
    }
    
    // UIStepper
    func customizeStepper(#color: UIColor) {
        UIStepper.appearance().tintColor = color
    }
    
    // UIProgressView
    func customizeProgressView(#primary: UIColor, secondary: UIColor) {
        UIProgressView.appearance().progressTintColor = primary
        //UIProgressView.appearance().trackTintColor = secondary
    }
}