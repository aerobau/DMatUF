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
    private var bgLayer = CALayer()
    private var fillLayer = CALayer()
    private var fillMask = CALayer()
    private var outlineLayer = CALayer()
    private var borderLayer = CALayer()
    
    var goal: Int = 100
    var value: Int = 0
    
    let fillColor = Color.primary2
    let emptyColor = Color.tvcOdd
    let strokeWidth = CGFloat(8.0)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = nil
    }
    
    func setup() {
        layer.addSublayer(borderLayer)
        layer.addSublayer(outlineLayer)
        layer.addSublayer(bgLayer)
        layer.addSublayer(fillLayer)
        
        // Draw Filling Layer
        let percent = CGFloat(CGFloat(value) / CGFloat(goal))
        let height = frame.width + ((frame.height - frame.width) * percent)
        fillMask.addSublayer(drawRectangle(frame: CGRectMake(0, frame.height - height, frame.width, height),
            color: UIColor.yellowColor().CGColor))
        fillLayer.addSublayer(drawThermometer(frame: CGRectMake(0, 0, frame.width, frame.height),
            filled: true,
            fillColor: fillColor.CGColor,
            stroked: false,
            strokeColor: nil,
            strokeWidth: strokeWidth))
        fillLayer.mask = fillMask
        
        // Draw Background Layer
        bgLayer.addSublayer(drawThermometer(frame: CGRectMake(0, 0, frame.width, frame.height),
            filled: true,
            fillColor: emptyColor.CGColor,
            stroked: false,
            strokeColor: nil,
            strokeWidth: strokeWidth))
        
        // Draw Stroke Layer
        outlineLayer.addSublayer(drawThermometer(frame: CGRectMake(0, 0, frame.width, frame.height),
            filled: true,
            fillColor: UIColor.clearColor().CGColor,
            stroked: true,
            strokeColor: UIColor.whiteColor().CGColor,
            strokeWidth: strokeWidth))
        
        borderLayer.addSublayer(drawThermometer(frame: CGRectMake(0, 0, frame.width, frame.height),
            filled: true,
            fillColor: UIColor.clearColor().CGColor,
            stroked: true,
            strokeColor: Color.tvcSeparator.CGColor,
            strokeWidth: strokeWidth + 2.0))
        
        
    }
    
    func drawThermometer(#frame: CGRect, filled: Bool, fillColor: CGColorRef?, stroked: Bool, strokeColor: CGColorRef?, strokeWidth: CGFloat) -> CAShapeLayer {
        let radius = CGFloat(frame.width / 4.0)
        let x = CGFloat(frame.width / 2.0)
        var path = UIBezierPath(arcCenter: CGPointMake(x, radius), radius: radius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        let p1 = CGPointMake(x - radius, frame.height - frame.width)
        path.addLineToPoint(p1)
        
        let varA = frame.width / 2.0
        let varBC = frame.width / 2.0
        let angle = acos((pow(varA, 2.0) - 2 * pow(varBC, 2.0))/(-2 * pow(varBC, 2.0))) / 2.0
        path.addArcWithCenter(CGPointMake(x, frame.height - x), radius: x, startAngle: CGFloat(3 * M_PI_2) - angle, endAngle: CGFloat(3 * M_PI_2) + angle, clockwise: false)
        
        path.closePath()
        
        let thermometer = CALayer(layer: path)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        
        if filled {
            shapeLayer.fillColor = fillColor
        }
        if stroked {
            shapeLayer.strokeColor = strokeColor
            shapeLayer.lineWidth = strokeWidth
        }

        return shapeLayer
    }
    
    func drawEllipse(#frame: CGRect, color: CGColorRef) -> CALayer {
        var layer = CALayer()
        layer.frame = frame
        layer.borderColor = color
        layer.borderWidth = strokeWidth
        layer.cornerRadius = frame.width / 2
        return layer
    }
    
    func drawRectangle(#frame: CGRect, color: CGColorRef) -> CALayer {
        var layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color
        return layer
    }
}

class CATable: UITableView, UITableViewDelegate, UITableViewDataSource {
    var goal: Int = 100
    var value: Int = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
        
        separatorColor = Color.tvcSeparator
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        
        layer.borderColor = Color.tvcSeparator.CGColor
        layer.borderWidth = 2.0
        
        
        
    }
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
        
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let n = frame.height / 3.0
        return CGFloat(n)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueReusableCellWithIdentifier("TableCellID", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.font = UIFont(name: Font.body1.fontName, size: 12.0)
        cell.textLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.font = UIFont(name: Font.body1.fontName, size: 30.0)
            
        cell.backgroundColor = Color.tvcEven
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Goal"
            cell.detailTextLabel?.text = "$\(goal)"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Raised"
            cell.detailTextLabel?.text = "$\(value)"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Progress"
            let percent = Int(floor(100.0 * CGFloat(value) / CGFloat(goal)))
            cell.detailTextLabel?.text = "\(percent)%"
        }

        return cell
    }
}

class CAButton: UIView {
    private var bgLayer = CALayer()

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        
        layer.borderColor = Color.tvcSeparator.CGColor
        layer.borderWidth = 1.0
        
        let grad = CAGradientLayer()
        grad.frame = bounds
        grad.colors = [Color.primary1.CGColor, Color.secondary1.CGColor]
        grad.locations = [0.0, 1.0]
        grad.startPoint = CGPointMake(0.5, 0)
        grad.endPoint = CGPointMake(0.5, 1.0)
        layer.addSublayer(grad)
    }
}
    
    