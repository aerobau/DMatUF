//
//  IMTheme.swift
//  IMThemeDemo
//
//  Created by Ian MacCallum on 11/10/14.
//

import UIKit

// MARK: Font Struct
struct Font {
    static let accent = UIFont(name: "Pacifico", size: 16.0)!
    static let header = UIFont(name: "agbookrounded-medium", size: 20.0)!
    static let subheader = UIFont(name: "AvenirLTStd-Black", size: 16.0)!
    static let body1 = UIFont(name: "AvenirLTStd-Roman", size: 14.0)!
    static let body2 = UIFont(name: "AvenirLTStd-Light", size: 10.0)!
}

// MARK: Color Struct
struct Color {
    static let primary1 = UIColor(red: 243 / 255.0, green: 112 / 255.0, blue: 33 / 255.0, alpha: 1.0)
    static let primary2 = UIColor(red: 1 / 255.0, green: 64 / 255.0, blue: 131 / 255.0, alpha: 1.0)
    static let secondary1 = UIColor(red: 244 / 255.0, green: 153 / 255.0, blue: 97 / 255.0, alpha: 1.0)
    static let secondary2 = UIColor(red: 97 / 255.0, green: 123 / 255.0, blue: 166 / 255.0, alpha: 1.0)
    
    static let tvcEven = UIColor(hue: 40.0/360.0, saturation: 0.01, brightness: 0.97, alpha: 1.0)
    static let tvcOdd = UIColor(hue: 70.0/360.0, saturation: 0.03, brightness: 0.93, alpha: 1.0)
    static let tvcImage = UIColor(hue: 60.0/360.0, saturation: 0.13, brightness: 0.79, alpha: 1.0)
    static let tvcIndicator = UIColor(hue: 66.0/360.0, saturation: 0.10, brightness: 0.79, alpha: 1.0)
    static let tvcSeparator = UIColor(hue: 66.0/360.0, saturation: 0.10, brightness: 0.86, alpha: 1.0)
    
    static let tvHeader = UIColor(hue: 60.0/360.0, saturation: 0.03, brightness: 0.91, alpha: 1.0)
    static let tvHeaderText = UIColor(hue: 4.0/360.0, saturation: 0.30, brightness: 0.34, alpha: 1.0)

}

// MARK: Theme Class
class Theme {

    init() {
        
        customizeNavBar(color: Color.primary1, titleFont: Font.header, buttonFont: Font.body1)
        customizeTabBar(color: Color.primary1, font: Font.body2)
        
    }
    
    func customizeNavBar(#color: UIColor, titleFont: UIFont, buttonFont: UIFont) {

        UINavigationBar.appearance().tintColor = color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: titleFont]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color, NSFontAttributeName: buttonFont], forState: UIControlState.Normal)
    }
    
    func customizeTabBar(#color: UIColor, font: UIFont) {
        UITabBar.appearance().tintColor = color
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Selected)
    }
    
    
    
    

    
    // UILabel
    func customizeLabel(#color: UIColor) {
        UILabel.appearance().textColor = color
    }
    
    

    
    // UIButton
    func customizeButton(#color: UIColor) {
        UIButton.appearance().setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
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