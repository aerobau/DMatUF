//
//  CAFunctions.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/6/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit



func printDocsDirectory() {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let files = NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory, error: nil)
    
    println("DOCUMENTS DIRECTORY: \(files?.count) Files")
    for file in files as [String] {
        println(file)
    }
}


enum DeviceType {
    case iPhone4s, iPhone5, iPhone5s, iPhone6, iPhone6Plus
    case iPad, iPadMini, iPadRetina, iPadMiniRetina
    case unknownDevice
}

extension UIDevice {
    class var version: Float {
       return (UIDevice.currentDevice().systemVersion as NSString).floatValue
    }
    
    class var type: DeviceType {
        if let size = UIScreen.mainScreen().currentMode?.size {
            switch size {
            case CGSizeMake(640 , 960 ) : return .iPhone4s
            case CGSizeMake(640 , 1136) : return .iPhone5
            case CGSizeMake(750 , 1334) : return .iPhone6
            case CGSizeMake(1242, 2208) : return .iPhone6Plus
            case CGSizeMake(1024, 768 ) : return .iPad
            case CGSizeMake(768 , 1024) : return .iPadMini
            case CGSizeMake(2048, 1536) : return .iPadRetina
            case CGSizeMake(1536, 2048) : return .iPadMiniRetina
            default : return .unknownDevice
            }
        }
        else {
            return .unknownDevice
        }
    }
}

extension UIApplication {
    class func tryURL(arr: [String]) {
        let application: UIApplication = UIApplication.sharedApplication()
        for url in arr {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }

}

extension UIView {
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension UIAlertView {
    class func errorMessage(title: String, message: String?) {
        let errorAlert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dismiss")
        
        errorAlert.show()
    }
}

extension Int {
    subscript(i: Int) -> Int? {
        let digits = reverse(String(self))
        
        if i >= digits.count {
            return nil
        }
        return String(digits[i]).toInt()
    }
}

extension UIImage {
    
    convenience init?(fromURL: String) {

        if let url = NSURL(string: fromURL) {
            if let data = NSData(contentsOfURL: url) {
                self.init(data: data)
            } else {
                self.init()
                return nil
            }
        } else {
            self.init()
            return nil
        }
    }
    
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage)
        UIGraphicsEndImageContext()
    }
    
    convenience init?(fileName: String, type: String) {
        if fileName == "" {
            self.init()
            return nil
        }
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    

        let path = "\(documentsPath)/\(fileName).\(type)"
        println(path)
        self.init(contentsOfFile: path)
    }
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func save(fileName: String, type: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        if type.lowercaseString == "png" {
            let path = "\(documentsPath)/\(fileName).\(type)"
            UIImagePNGRepresentation(self).writeToFile(path, atomically: true)
        } else if type.lowercaseString == "jpg" {
            let path = "\(documentsPath)/\(fileName).\(type)"
            UIImageJPEGRepresentation(self, 1.0).writeToFile(path, atomically: true)
        } else {

        }
    }
}

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension UINavigationController {
    func toggleNavBar() {
        if navigationBar.hidden {
            
            navigationBar.alpha = 0
            navigationBar.hidden = false
            UIView.animateWithDuration(0.2) {
                self.navigationBar.alpha = 1.0
            }
            
        } else {
            
            UIView.animateWithDuration(0.2, animations: {
                self.navigationBar.alpha = 0
                }, completion: { complete in
                    if complete {
                        self.navigationBar.hidden = true
                    }
            })
        }
    }
}

extension UITabBarController {
    func toggleTabBar() {
        if tabBar.hidden {
            
            tabBar.alpha = 0
            tabBar.hidden = false
            UIView.animateWithDuration(0.2) {
                self.tabBar.alpha = 1.0
            }
            
        } else {
            
            UIView.animateWithDuration(0.2, animations: {
                self.tabBar.alpha = 0
            }, completion: { complete in
                if complete {
                    self.tabBar.hidden = true
                }
            })
        }
    }
}

extension UIViewController {
    func toggleStatusBar() {
        if prefersStatusBarHidden() {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        } else {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        }
    }
}

extension NSDateComponents {
    convenience init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)  {
        self.init()
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.calendar = NSCalendar.currentCalendar()
    }
}