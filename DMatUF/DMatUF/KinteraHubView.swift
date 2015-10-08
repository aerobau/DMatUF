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

    
    var goal: Int = 100
    var value: Int = 0
    
    let fillColor = Color.primary2
    let emptyColor = Color.tvcOdd
    let strokeWidth = CGFloat(8.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = nil
        
    }

    func setup() {
        layer.sublayers = []
        
        let bgLayer = CALayer()
        let fillLayer = CALayer()
        let fillMask = CALayer()
        let outlineLayer = CALayer()
        let borderLayer = CALayer()
        
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
            strokeWidth: strokeWidth + 4.0))
    }
    
    func drawThermometer(frame frame: CGRect, filled: Bool, fillColor: CGColorRef?, stroked: Bool, strokeColor: CGColorRef?, strokeWidth: CGFloat) -> CAShapeLayer {
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
    
    func drawEllipse(frame frame: CGRect, color: CGColorRef) -> CALayer {
        var layer = CALayer()
        layer.frame = frame
        layer.borderColor = color
        layer.borderWidth = strokeWidth
        layer.cornerRadius = frame.width / 2
        return layer
    }
    
    func drawRectangle(frame frame: CGRect, color: CGColorRef) -> CALayer {
        var layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color
        return layer
    }
}

class CATable: UITableView, UITableViewDelegate, UITableViewDataSource {
    var goal: Int = 100
    var value: Int = 0
    var name: String = ""
    var lastUpdated: String = "dcfgvhbj"
    var url: String = ""
    
    var task: NSURLSessionDataTask?

    required init?(coder aDecoder: NSCoder) {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let n = frame.height / 5.0
        return CGFloat(n)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueReusableCellWithIdentifier("TableCellID", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.font = UIFont(name: Font.body1.fontName, size: cell.contentView.frame.width / 16.0)
        cell.textLabel?.textColor = UIColor.grayColor()
        
        let font = UIFont(name: Font.body1.fontName, size: cell.contentView.frame.width / 8.0)!
        cell.detailTextLabel?.attributedText = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: Color.primary1, NSFontAttributeName: font])
        
        
        cell.backgroundColor = Color.tvcEven
        
        if indexPath.row == 0 {
            let titleFont = UIFont(name: Font.header.fontName, size: cell.contentView.frame.width / 12.0)!
            let subtitleFont = UIFont(name: Font.body1.fontName, size: cell.contentView.frame.width / 24.0)!
            cell.textLabel?.attributedText = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: Color.primary2, NSFontAttributeName: titleFont])
            cell.detailTextLabel?.attributedText = NSAttributedString(string: "Updated: \(lastUpdated)", attributes: [NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: subtitleFont])
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Goal"
            cell.detailTextLabel?.text = "$\(goal)"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Raised"
            cell.detailTextLabel?.text = "$\(value)"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "Progress"
            let percent = Int(floor(100.0 * CGFloat(value) / CGFloat(goal)))
            cell.detailTextLabel?.text = "\(percent)%"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil

            let height = CGFloat(60.0)
            let button = CAButton(frame: CGRectMake(cell.separatorInset.left, cell.frame.height / 2.0 - height / 2.0, cell.frame.width - cell.separatorInset.left - cell.separatorInset.right, height), url: url)
            cell.contentView.addSubview(button)
        }
        return cell
    }
}

class CAButton: UIButton {
    var url = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, url: String) {
        super.init(frame: frame)
        self.url = url
        
        addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        
        layer.borderColor = Color.tvcSeparator.CGColor
        layer.borderWidth = 2.0
        
        setBackgroundImage(backgroundImage(), forState: UIControlState.Normal)
        setBackgroundImage(pressedImage(), forState: UIControlState.Highlighted)
        setBackgroundImage(pressedImage(), forState: UIControlState.Selected)
        
        setAttributedTitle(NSAttributedString(string: "My Kintera Page", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Font.accent.fontName, size: 20.0)!]), forState: UIControlState.Normal)
        
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func buttonPressed(sender: AnyObject?) {
        print("Button pressed")
        UIApplication.tryURL([url])
    }

    func backgroundImage() -> UIImage? {
        
        var image: UIImage?
        
        let grad = CAGradientLayer()
        grad.frame = bounds
        grad.colors = [Color.primary1.CGColor, Color.secondary1.CGColor]
        grad.locations = [0.0, 1.0]
        grad.startPoint = CGPointMake(0.5, 0)
        grad.endPoint = CGPointMake(0.5, 1.0)
        
        UIGraphicsBeginImageContext(grad.bounds.size);
        grad.renderInContext(UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }

    func pressedImage() -> UIImage? {
        
        var image: UIImage?
        
        let grad = CAGradientLayer()
        grad.frame = bounds
        grad.colors = [Color.primary1.CGColor, Color.secondary1.CGColor]
        grad.locations = [0.0, 1.0]
        grad.startPoint = CGPointMake(0.5, 0)
        grad.endPoint = CGPointMake(0.5, 1.0)
        
        let overlay = CALayer()
        overlay.frame = bounds
        overlay.backgroundColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        
        UIGraphicsBeginImageContext(grad.bounds.size);
        grad.renderInContext(UIGraphicsGetCurrentContext()!)
        overlay.renderInContext(UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
}