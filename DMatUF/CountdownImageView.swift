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
    var labels: [UILabel] = []
    var standComponents: NSDateComponents!
    var sitComponents: NSDateComponents!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        standComponents = NSDateComponents(year: 2015, month: 3, day: 14, hour: 12, minute: 2, second: 0)
        sitComponents = NSDateComponents(year: 2015, month: 3, day: 15, hour: 14, minute: 12, second: 0)
        
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
        
        for i in 0..<15 {
            let label = UILabel()
            addSubview(label)
            labels.append(label)
        }
        
        
        labels[3].text = ":"
        labels[6].text = ":"
        labels[9].text = ":"
        labels[12].text = "D\nM"
        labels[13].text = "a\nt"
        labels[14].text = "U\nF"
        
        for label in labels {
            label.font = UIFont(name: Font.header.fontName, size: 48.0)
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Center
            label.baselineAdjustment = UIBaselineAdjustment.None
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
        }
        
        labels[3].textColor = Color.primary2
        labels[6].textColor = Color.primary2
        labels[9].textColor = Color.primary2
        labels[12].textColor = Color.primary2
        labels[14].textColor = Color.primary2
    }
    

    
    func updateLabelText() {
        
        let nowComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: NSDate())
        
        if standComponents.date!.timeIntervalSince1970 >= NSDate().timeIntervalSince1970 {
            
            let components = NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDateComponents: nowComponents, toDateComponents: standComponents, options: nil)
            
            let daysString = NSString(format: "%03d", components.day) as String
            let hoursString = NSString(format: "%02d", components.hour) as String
            let minutesString = NSString(format: "%02d", components.minute) as String
            let secondsString = NSString(format: "%02d", components.second) as String
            
            let daysArray = map(daysString) { s -> String in String(s) }
            let hoursArray = map(hoursString) { s -> String in String(s) }
            let minutesArray = map(minutesString) { s -> String in String(s) }
            let secondsArray = map(secondsString) { s -> String in String(s) }
            
            // Days
            labels[0].text = daysArray[0]
            labels[1].text = daysArray[1]
            labels[2].text = daysArray[2]
            // Hours
            labels[4].text = hoursArray[0]
            labels[5].text = hoursArray[1]
            // Minutes
            labels[7].text = minutesArray[0]
            labels[8].text = minutesArray[1]
            // Seconds
            labels[10].text = secondsArray[0]
            labels[11].text = secondsArray[1]
            
          
        } else if standComponents.date!.timeIntervalSince1970 < NSDate().timeIntervalSince1970 && NSDate().timeIntervalSince1970 < sitComponents.date!.timeIntervalSince1970 {
            
            let components = NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDateComponents: nowComponents, toDateComponents: sitComponents, options: nil)

            let daysString = NSString(format: "%03d", components.day) as String
            let hoursString = NSString(format: "%02d", components.hour) as String
            let minutesString = NSString(format: "%02d", components.minute) as String
            let secondsString = NSString(format: "%02d", components.second) as String
            

            
            let daysArray = map(daysString) { s -> String in String(s) }
            let hoursArray = map(hoursString) { s -> String in String(s) }
            let minutesArray = map(minutesString) { s -> String in String(s) }
            let secondsArray = map(secondsString) { s -> String in String(s) }
            
            // Days
            labels[0].text = daysArray[0]
            labels[1].text = daysArray[1]
            labels[2].text = daysArray[2]
            // Hours
            labels[4].text = hoursArray[0]
            labels[5].text = hoursArray[1]
            // Minutes
            labels[7].text = minutesArray[0]
            labels[8].text = minutesArray[1]
            // Seconds
            labels[10].text = secondsArray[0]
            labels[11].text = secondsArray[1]

            
        } else {
            let message = "THANKYOUDMatUF!"
            let messageArray = map(message) { s -> String in String(s) }
            for i in 0..<labels.count {
                labels[i].text = messageArray[i]
            }
        }
    }
    
    func updateLabelFrames() {
        setLabel(&labels[0], rect: CGRectMake(frame.width * (36.0 / 320.0), frame.height * (132.0 / 302.0), frame.width * (18.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -5.0)
        
        setLabel(&labels[1], rect: CGRectMake(frame.width * (54.0 / 320.0), frame.height * (124.0 / 302.0) , frame.width * (17.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -2.0)
        
        setLabel(&labels[2], rect: CGRectMake(frame.width * (71.0 / 320.0), frame.height * (131.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: 0.0)
        
        setLabel(&labels[3], rect: CGRectMake(frame.width * (87.0 / 320.0), frame.height * (126.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: 0.0)
        
        setLabel(&labels[4], rect: CGRectMake(frame.width * (103.0 / 320.0), frame.height * (133.0 / 302.0) , frame.width * (15.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: 0.0)
        
        setLabel(&labels[5], rect: CGRectMake(frame.width * (118.0 / 320.0), frame.height * (133.0 / 302.0) , frame.width * (15.0 / 320.0), frame.height * (26.0 / 151.0)), rotation: -1.0)
        
        setLabel(&labels[6], rect: CGRectMake(frame.width * (134.0 / 320.0), frame.height * (125.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -1.0)
        
        setLabel(&labels[7], rect: CGRectMake(frame.width * (150.0 / 320.0), frame.height * (133.0 / 302.0) , frame.width * (17.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -1.0)
        
        setLabel(&labels[8], rect: CGRectMake(frame.width * (167.0 / 320.0), frame.height * (143.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (24.0 / 151.0)), rotation: -1.0)
        
        setLabel(&labels[9], rect: CGRectMake(frame.width * (186.0 / 320.0), frame.height * (132.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (23.0 / 151.0)), rotation: 0.0)
        
        setLabel(&labels[10], rect: CGRectMake(frame.width * (198.0 / 320.0), frame.height * (132.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (23.0 / 151.0)), rotation: 0.0)
        
        setLabel(&labels[11], rect: CGRectMake(frame.width * (214.0 / 320.0), frame.height * (138.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 3.0)
        
        setLabel(&labels[12], rect: CGRectMake(frame.width * (230.0 / 320.0), frame.height * (138.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 3.0)
        
        setLabel(&labels[13], rect: CGRectMake(frame.width * (246.0 / 320.0), frame.height * (139.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 1.0)
        
        setLabel(&labels[14], rect: CGRectMake(frame.width * (262.0 / 320.0), frame.height * (137.0 / 302.0) , frame.width * (16.0 / 320.0), frame.height * (25.0 / 151.0)), rotation: 1.0)
    }
}