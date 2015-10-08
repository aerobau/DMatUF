//
//  MapViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/25/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit



class MapView: UIImageView {
    
    var buttons: [AlertButton]!
    
    init(frame: CGRect, gesture: UITapGestureRecognizer) {
        super.init(frame: frame)
        
        userInteractionEnabled = true
        image = UIImage(named: "Map")
        setup(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(gesture: UITapGestureRecognizer?) {
        let button1 = AlertButton(title: "Study Room", message: "Stay on top of your school work in the Study Room, sponsored by Study Edge!", frame: CGRect(x: 85, y: 25, width: 90, height: 50), rotation: 0)
        let button2 = AlertButton(title: "Hobby Corner", message: "This is where you'll find all the magazines, arts and crafts, computers, and even video games to help pass the time at the event and keep you busy!", frame: CGRect(x: 108, y: 86, width: 43, height: 20), rotation: 0)
        let button3 = AlertButton(title: "Jail Break", message: "Volunteers have been put in DM Jail! They set a bail and can't get out until they have raised their bail.", frame: CGRect(x: 154, y: 86, width: 30, height: 20), rotation: 0)
        let button4 = AlertButton(title: "Visitor Corner", message: "An area for visitors to see Dancers and volunteers.", frame: CGRect(x: 186, y: 86, width: 40, height: 20), rotation: 0)
        let button5 = AlertButton(title: "Silent Auction", message: "Check out the items in the silent auction, all proceeds For The Kids.", frame: CGRect(x: 224, y: 105, width: 22, height: 20), rotation: 0)
        let button6 = AlertButton(title: "Tech Booth", message: "Find the Technology Team here operating all of the music, videos, DM Live Feed and more!", frame: CGRect(x: 224, y: 126, width: 22, height: 30), rotation: 0)
        let button7 = AlertButton(title: "Visitor Entrance", message: "All visitors must enter at Gate 1. In this area, you will also find the Marketing Table, Recruitment Team giving tours and the Community Events team.", frame: CGRect(x: 255, y: 34, width: 16, height: 50), rotation: 40)
        let button8 = AlertButton(title: "Main Stage", message: "Learn the Linedance, hear Miracle Stories and see many other incredible performances on the Main Stage.", frame: CGRect(x: 88, y: 113, width: 22, height: 56), rotation: 0)
        let button9 = AlertButton(title: "Hospitality Corner", message: "If you're hungry, thirsty, or just want a snack, here is where you'll be able to fill yourself with all the freshly made and donated food throughout the event.", frame: CGRect(x: 91, y: 177, width: 23, height: 10), rotation: 40)
        let button10 = AlertButton(title: "Photo Booth", message: "Document your memories at Dance Marathon at the Photo Booth with the Art and Layout team.", frame: CGRect(x: 119, y: 178, width: 18, height: 13), rotation: 0)
        let button11 = AlertButton(title: "Side Stage", message: "This is where all the families will speak, where the Morale team will be for each Linedance, and much more throughout the Event!", frame: CGRect(x: 140, y: 178, width: 57, height: 13), rotation: 0)
        let button12 = AlertButton(title: "Basket Ball Hoops", message: "Take a break from dancing and shoot some hoops at Gate 2.", frame: CGRect(x: 200, y: 178, width: 18, height: 13), rotation: 0)
        let button13 = AlertButton(title: "Meals", message: "Dancers, stay nourished with all of the delicious meals provided by our partners.", frame: CGRect(x: 67, y: 191, width: 13, height: 43), rotation: 40)
        let button14 = AlertButton(title: "Medical Room", message: "If you need medical attention at any point throughout Dance Marathon, visit the Med. Room for assistance.", frame: CGRect(x: 77, y: 221, width: 16, height: 12), rotation: 40)
        let button15 = AlertButton(title: "Men's Locker Room", message: "Male Dancers will keep their belongings here.", frame: CGRect(x: 98, y: 207, width: 22, height: 28), rotation: 0)
        let button16 = AlertButton(title: "Women's Locker Room", message: "Female Dancers will keep their belongings here.", frame: CGRect(x: 208, y: 208, width: 29, height: 26), rotation: 0)
        
        buttons = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12, button13, button14, button15, button16]
        
        for button in buttons {
            button.tapGesture.requireGestureRecognizerToFail(gesture!)
            addSubview(button)
        }
    }
}

class AlertButton: UIView, UIAlertViewDelegate {
    
    var alertView: UIAlertView?
    var tapGesture: UITapGestureRecognizer!
    
    init(title: String, message: String, frame: CGRect, rotation: CGFloat) {
        super.init(frame: frame)
        
        userInteractionEnabled = true
        transform = CGAffineTransformMakeRotation(rotation * CGFloat(M_PI) / 180.0)
        
        // backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        
        alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dismiss")
        
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        alertView?.show()
    }
}

class MapViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    var imageView: MapView!
    var pinchPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Analytics
        GA.sendScreenView(name: "MapView")

        // Setup Gesture Recognizers
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        scrollView.addGestureRecognizer(tapRecognizer)
        scrollView.addGestureRecognizer(doubleTapRecognizer)

        let image = UIImage(named: "Map")!
        let x: CGFloat = (scrollView.frame.width - image.size.width) / 2.0
        let y: CGFloat = (scrollView.frame.height - image.size.height) / 2.0
        imageView = MapView(frame: CGRect(origin: CGPointMake(0, 0), size:image.size), gesture: doubleTapRecognizer)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        
        // Add Description Label
//        let label = UILabel(frame: CGRect(x: 0, y: 64, width: imageView.frame.width, height: 30))
//        label.text = "Select Areas for Description"
//        label.textAlignment = .Center
//        label.font = Font.subheader.fontWithSize(18)
//        scrollView.addSubview(label)
        
        
        // Scroll View Properties
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.375
        scrollView.contentSize = image.size
        scrollView.sizeToFit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height

        centerScrollViewContents()
    }
    
    @IBAction func infoButtonPressed(sender: UIBarButtonItem) {
        let alert = UIAlertView(title: "Interactive Map", message: "Tap an area to learn what goes on there or zoom to get a better view!", delegate: self, cancelButtonTitle: "Dismiss")
        alert.show()
    }
    
    
    func centerScrollViewContents() {
        let boundSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundSize.width {
            contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundSize.height {
            contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
    }
}

extension MapViewController {

    func handleTap(recognizer: UITapGestureRecognizer) {
        navigationController?.toggleNavBar()
        tabBarController?.toggleTabBar()
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if scrollView.zoomScale == scrollView.maximumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            return
        }
        
        let pointInView = recognizer.locationInView(imageView)
        
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
}

extension MapViewController: UIGestureRecognizerDelegate {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        pinchPoint = imageView.center
    }
}

extension MapViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}

