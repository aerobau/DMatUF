//
//  CAFunctions.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/6/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

enum DeviceType {
    case iPhone4s, iPhone5, iPhone5s, iPhone6, iPhone6Plus
    case iPad, iPadMini, iPadRetina, iPadMiniRetina
    case unknownDevice
}


class CAF: NSObject, UIAlertViewDelegate {
    class var version: Float {
        get {
            return (UIDevice.currentDevice().systemVersion as NSString).floatValue
        }
    }
    
    class var deviceType: DeviceType {
        
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

    class func openURL(arr: [String]) {
        let application: UIApplication = UIApplication.sharedApplication()
        for url in arr {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
    
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
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
}
