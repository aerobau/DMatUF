//
//  TodayViewController.swift
//  DM Widget
//
//  Created by Ian MacCallum on 12/4/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var dateLabel: UILabel!

    var timer: NSTimer?

    var dateFormatter = NSDateFormatter()
    var startDate: NSDate?
    var futureTime: NSDate?
    var duration: NSTimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func updateTimer(myTimer: NSTimer) {
        println("updateTimer")
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
}
//class TodayViewController: UIViewController, NCWidgetProviding {
//    
//    @IBOutlet weak var dateLabel: UILabel!
//    
//    var dateFormatter = NSDateFormatter()
//    var startDate: NSDate?
//    var futureTime: NSDate?
//    var timer: NSTimer?
//    var duration: NSTimeInterval?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setEventDate()
//        
//        if timer == nil {
//            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
//        }
//        
//        dateLabel.text = dateStringFromTimeInterval(0)
//        
//        let now = NSDate()
//        let currentCalendar = NSCalendar.currentCalendar()
//    }
//    
//    func updateTimer(myTimer: NSTimer) {
//        startDate = NSDate()
//        if futureTime != nil {
//            var duration = futureTime!.timeIntervalSinceDate(startDate!)
//            dateLabel.text = dateStringFromTimeInterval(duration)
//        }
//    }
//    
//    func dateStringFromTimeInterval(timeInterval: NSTimeInterval) -> String {
//        dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss.SS"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//        var date = NSDate(timeIntervalSince1970: timeInterval)
//        return dateFormatter.stringFromDate(date)
//    }
//    
//    func setEventDate() {
//        // Event Date
//        var components = NSDateComponents()
//        components.year = 2015
//        components.month = 03
//        components.day = 14
//        components.hour = 09
//        components.minute = 00
//        components.second = 00
//        futureTime = components.date
//        println(futureTime?.timeIntervalSince1970)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
//        updateTimer(timer!)
//        completionHandler(NCUpdateResult.NewData)
//    }
//}