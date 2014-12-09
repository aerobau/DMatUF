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
    var max: Int = 100
    var currentValue: Int = 0
    
    var fillColor: UIColor = UIColor.blueColor() {
        didSet {
            fillingView?.backgroundColor = fillColor
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    func setupView() {
        setupBackgroundView()
        setupFillingView()
        setupImageView()
        setupPercentLabel()
    }
    
    func setupBackgroundView() {
        backgroundView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        backgroundView?.backgroundColor = UIColor.whiteColor()
        addSubview(backgroundView!)
    }
    
    func setupFillingView() {
        println("currentValue: \(currentValue)")
        println("max: \(max)")
        
        let percent = CGFloat(Float(currentValue)/Float(max ?? 100))
        let height = CGFloat(60.0) + (CGFloat(168.0) * percent)
        fillingView = UIView(frame: CGRectMake(0, self.frame.height - height, self.frame.width, height))
        fillingView?.backgroundColor = fillColor
        addSubview(fillingView!)
        
    }
    
    func setupImageView() {
        imageView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        imageView?.image = UIImage(named: "Thermometer")
        imageView?.backgroundColor = UIColor.clearColor()
        addSubview(imageView!)
    }
    
    func setupPercentLabel() {
        let label = UILabel(frame: CGRectMake(0, (frame.height - 64.0 + (64.0 - 21.0) / 2.0), frame.width, 21.0))
        let percent = Int(CGFloat(Float(currentValue)/Float(max ?? 100)) * 100.0)
        var paragraphStyle = NSMutableParagraphStyle.alloc()
        paragraphStyle.alignment = NSTextAlignment.Center
        label.attributedText = NSAttributedString(string: "\(percent)%", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSParagraphStyleAttributeName: paragraphStyle])

        addSubview(label)
        
        
    }
}