//
//  ProgressBar.swift
//  DMatUF
//
//  Created by Ian MacCallum on 11/19/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit


class ProgressBar: UIView {
    // Views
    var backgroundView: UIView?
    var fillingView: UIView?
    var imageView: UIImageView?

    // Properties
    var max: Int?
    var currentValue: Int?
    
    var fillColor: UIColor = UIColor.orangeColor()
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func updateProgress(toValue value: Int, isAnimated animated: Bool) {
        println("Max \(max)")
        println("Val \(value)")
        
        
        
        let percent = CGFloat(Float(value)/Float(max ?? 100))
        let duration = CGFloat(5.0) * percent

        fillingView?.backgroundColor = updateColor(toValue: percent)
        
        if animated {
            fillingView?.frame = CGRectMake(0, frame.height - 42.0, frame.width, 42.0)

            delay(0.3) {
                UIView.animateWithDuration(NSTimeInterval(duration), animations: { () -> Void in
                    let height = CGFloat(42.0) + ((CGFloat(self.frame.height) - CGFloat(42.0)) * percent)
                    self.fillingView?.frame = CGRectMake(0, self.frame.height - height, self.frame.width, height)
                })
            }
        } else {
            fillingView?.frame = CGRectMake(0, frame.height - 42.0, frame.width, 42.0)
        }
    }
    
    func updateColor(toValue value: CGFloat) -> UIColor {
        if 0 <= value && value < 0.25 {
            return UIColor.redColor()
        } else if 0.25 <= value && value < 0.5 {
            return UIColor.orangeColor()
        } else if 0.5 <= value && value < 0.75 {
            return UIColor.yellowColor()
        } else if 0.75 <= value && value < 1.0 {
            return UIColor.greenColor()
        } else if value >= 1.00 {
            return UIColor.blueColor()
        }
        
        return UIColor.redColor()
    }
    
    func setupView() {
        setupBackgroundView()
        setupFillingView()
        setupImageView()
    }
    
    func setupBackgroundView() {
        backgroundView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        backgroundView?.backgroundColor = UIColor.yellowColor()
        addSubview(backgroundView!)
    }
    
    func setupFillingView() {
        fillingView = UIView(frame: CGRectMake(0, frame.height - 42.0, frame.width, 42.0))
        fillingView?.backgroundColor = UIColor.blueColor()
        addSubview(fillingView!)
        
    }
    
    func setupImageView() {
        imageView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        imageView?.image = UIImage(named: "thermometer")
        imageView?.backgroundColor = UIColor.clearColor()
        addSubview(imageView!)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}