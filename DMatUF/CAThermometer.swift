//
//  CGThermometer.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/7/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import QuartzCore

class CAThermometer: UIView {
    // Base Layer
    var bgLayer = CALayer()
    var circleLayer = CALayer()
    var rectLayer = CALayer()
    
    let thermometerOutlineColor = UIColor.blackColor().CGColor
    let thermometerBorderWidth = CGFloat(4.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        
        layer.addSublayer(bgLayer)

        layer.addSublayer(circleLayer)
        layer.addSublayer(rectLayer)

    
        // Draw BG
//        drawRectangle(layer: bgLayer, frame: CGRectMake(0, 0, frame.width, frame.height))
        
        // Draw Rectangle
//        drawRectangle(layer: rectLayer, frame: CGRectMake(frame.width / 3.0, 0, frame.width / 3.0, frame.height))
        
        // Draw Circle
//        drawEllipse(layer: circleLayer, frame: CGRectMake(0, frame.height - frame.width, frame.width, frame.width))
        
//        bgLayer.mask = circleLayer
//        rectLayer.mask = circleLayer
        thermometerBezierPath(CGRectMake(0, 0, frame.width, frame.height))
    }
    
    func thermometerBezierPath(frame: CGRect) {
        let radius = CGFloat(frame.width / 6.0)
        let x = CGFloat(frame.width / 2.0)
        var path = UIBezierPath(arcCenter: CGPointMake(x, radius), radius: radius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        let p1 = CGPointMake(x - radius, frame.height - frame.width)
        path.addLineToPoint(p1)
        
        let varA = frame.width / 3.0
        let varBC = frame.width / 2.0
        
        let angle = acos((pow(varA, 2.0) - 2 * pow(varBC, 2.0))/(-2 * pow(varBC, 2.0))) / 2.0
        
        path.addArcWithCenter(CGPointMake(x, frame.height - x), radius: x, startAngle: CGFloat(3 * M_PI_2) - angle, endAngle: CGFloat(3 * M_PI_2) + angle, clockwise: false)
        
        path.closePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        
        shapeLayer.strokeColor = UIColor.greenColor().CGColor
        shapeLayer.lineWidth = 4.0
        
        shapeLayer.fillColor = nil
        bgLayer.addSublayer(shapeLayer)
        
    }
    
    func drawEllipse(#layer: CALayer, frame: CGRect) {
        layer.frame = frame
        layer.borderColor = thermometerOutlineColor
        layer.borderWidth = thermometerBorderWidth
        layer.cornerRadius = frame.width / 2
//        layer.backgroundColor = UIColor.greenColor().CGColor
        
    }
    
    
    
    func drawRectangle(#layer: CALayer, frame: CGRect) {
        layer.frame = frame
        layer.borderColor = thermometerOutlineColor
        layer.borderWidth = thermometerBorderWidth
        layer.backgroundColor = UIColor.blueColor().CGColor
        
    }

  
}