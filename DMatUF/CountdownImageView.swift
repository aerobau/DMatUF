//
//  CountDown.swift
//  DMatUF
//
//  Created by Ian MacCallum on 12/16/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

class CountdownImageView: UIImageView {
    
    var timer: NSTimer?
    let endDate = NSDate(fromString: "03/14/2015 12:00:00", format: .Standard, timeZone: .EST)

    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    var label5 = UILabel()
    var label6 = UILabel()
    var label7 = UILabel()
    var label8 = UILabel()
    var label9 = UILabel()
    var label10 = UILabel()
    var label11 = UILabel()
    var label12 = UILabel()
    var label13 = UILabel()
    var label14 = UILabel()
    var label15 = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initializeLabels()


    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateLabelText", userInfo: nil, repeats: true)
            timer?.fire()
        }
        updateLabelFrames()
    }
    
    
    
    func setLabel(inout label: UILabel, rect: CGRect, rotation: CGFloat) {
        func toRadians(degrees: CGFloat) -> CGFloat {
            return CGFloat(M_PI) * degrees / 180.0
        }
        label.frame = rect
        label.transform = CGAffineTransformMakeRotation(toRadians(rotation))
    }
    
    func initializeLabels() {
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        addSubview(label4)
        addSubview(label5)
        addSubview(label6)
        addSubview(label7)
        addSubview(label8)
        addSubview(label9)
        addSubview(label10)
        addSubview(label11)
        addSubview(label12)
        addSubview(label13)
        addSubview(label14)
        addSubview(label15)
        
        let labels = [label1, label2, label3, label4, label5, label6, label7, label8, label9, label10, label11, label12, label13, label14, label15]
        
        label4.text = ":"
        label7.text = ":"
        label10.text = ":"
        label13.text = "D\nM"
        label14.text = "a\nt"
        label15.text = "U\nF"
        
        for label in labels {
            label.font = UIFont(name: Font.header.fontName, size: 48.0)
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Center
            label.baselineAdjustment = UIBaselineAdjustment.None
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
        }
        
        label4.textColor = Color.primary2
        label7.textColor = Color.primary2
        label10.textColor = Color.primary2
        label13.textColor = Color.primary2
        label15.textColor = Color.primary2

    }
    
    func updateLabelText() {
        
        if endDate.timeIntervalSince1970 >= NSDate().timeIntervalSince1970 {

            let calendar = NSCalendar.currentCalendar()
            let flags = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
            let components = calendar.components(flags, fromDate: NSDate(), toDate: endDate, options: nil)

            
            
            let date = components.date ?? NSDate(timeIntervalSince1970: endDate.timeIntervalSinceNow).dateByAddingDays(-1).dateByAddingHours(1)
            
            let dateString = date.toString(format: .Custom("DDD:HH:mm:ss"), timeZone: .UTC)
            
            let charArray = Array(dateString)
            
            // Days
            label1.text = "\(charArray[0])"
            label2.text = "\(charArray[1])"
            label3.text = "\(charArray[2])"
            // Hours
            label5.text = "\(charArray[4])"
            label6.text = "\(charArray[5])"
            // Minutes
            label8.text = "\(charArray[7])"
            label9.text = "\(charArray[8])"
            // Seconds
            label11.text = "\(charArray[10])"
            label12.text = "\(charArray[11])"
        } else {
            println("DM Started")
        }
    }
    
    func updateLabelFrames() {
        setLabel(&label1, rect: CGRectMake(frame.width * (36.0 / 320.0), frame.height * (132.0 / 302.0), frame.width * (18.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -5.0)
        
        setLabel(&label2, rect: CGRectMake(frame.width * (54.0 / 320.0), frame.height * (124.0 / 302.0) , frame.width * (17.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -2.0)
        
        setLabel(&label3, rect: CGRectMake(frame.width * (71.0 / 320.0), frame.height * (131.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: 0.0)
        
        setLabel(&label4, rect: CGRectMake(frame.width * (87.0 / 320.0), frame.height * (126.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: 0.0)
        
        setLabel(&label5, rect: CGRectMake(frame.width * (103.0 / 320.0), frame.height * (133.0 / 302.0) , frame.width * (15.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: 0.0)
        
        setLabel(&label6, rect: CGRectMake(frame.width * (118.0 / 320.0), frame.height * (133.0 / 302.0) , frame.width * (15.0 / 320.0), frame.height * (26.0 / 151.0)), rotation: -1.0)
        
        setLabel(&label7, rect: CGRectMake(frame.width * (134.0 / 320.0), frame.height * (125.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -1.0)
        
        setLabel(&label8, rect: CGRectMake(frame.width * (150.0 / 320.0), frame.height * (133.0 / 302.0) , frame.width * (17.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -1.0)
        
        setLabel(&label9, rect: CGRectMake(frame.width * (167.0 / 320.0), frame.height * (143.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -1.0)
        
        setLabel(&label10, rect: CGRectMake(frame.width * (186.0 / 320.0), frame.height * (132.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (23.0 / 151.0)), rotation: 0.0)
        
        setLabel(&label11, rect: CGRectMake(frame.width * (198.0 / 320.0), frame.height * (132.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (23.0 / 151.0)), rotation: 0.0)
        
        setLabel(&label12, rect: CGRectMake(frame.width * (214.0 / 320.0), frame.height * (138.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 3.0)
        
        setLabel(&label13, rect: CGRectMake(frame.width * (230.0 / 320.0), frame.height * (138.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 3.0)
        
        setLabel(&label14, rect: CGRectMake(frame.width * (246.0 / 320.0), frame.height * (139.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 1.0)
        
        setLabel(&label15, rect: CGRectMake(frame.width * (262.0 / 320.0), frame.height * (137.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 1.0)
    }
}