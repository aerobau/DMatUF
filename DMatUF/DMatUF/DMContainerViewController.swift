//
//  DMContainerViewController.swift
//  DMatUF
//
//  Created by Alexander Robau on 9/29/15.
//  Copyright © 2015 DMatUF. All rights reserved.
//

import UIKit


// Enumeration DMMainViewControllerOption
// Keeps track of the name of the view controller option in the side panel as it's raw value and
// the name of the view contoller's storyboard identifier as a computational variable controllerName
enum DMMainViewControllerOption: String {
    // The possible casses of Home, Map, Game, events, meet the kids, fundraise, about
    case Home = "Home"
    case Map = "Map"
    case Game = "Game"
    case Events = "Events"
    case MeetTheKids = "Meet the Kids"
    case Fundraise = "Fundraise"
    case About = "About"
    
    // Computed variable which returns the view controller identifier in the storyboard of the
    // option
    var controllerName: String {
        // Switching the enumeration's type to make sure that the correct view controller name is 
        // returned to identify the correct storyboard entity
        switch self {
            case .Home: return "DMHomeViewController"
            case .Map: return "DMMapViewController"
            case .Game: return "DMGameViewController"
            case .Events: return "DMEventsViewController"
            case .MeetTheKids: return "DMMeetTheKidsViewController"
            case .Fundraise: return "DMFundraiseViewController"
            case .About: return "DMAboutViewController"
        }
    }
    
    var iconName: String {
        // Switching the enumeration's type to make sure that the correct view controller name is
        // returned to identify the correct storyboard entity
        switch self {
        case .Home: return "TabStarIcon"
        case .Map: return "TabMapIcon"
        case .Game: return "TabGameIcon"
        case .Events: return "TabCalendarIcon"
        case .MeetTheKids: return "TabBalloonIcon"
        case .Fundraise: return "TabFundraiseIcon"
        case .About: return "TabAboutIcon"
        }
    }
}

// class DMContainerViewController
// Acts as a container for the Side panel view controller and the main view controller being
// presented.  Also keeps track of their respective navigation controllers
// Handles the animation of the sliding in and out of the panel, also conforms to two protocols
// to be able to properly change its view accordingly
class DMContainerViewController: UIViewController, DMMainDelegate, DMPanelDelegate {
    // Simple boolean to represent if the panel is currently visible
    var panelClosed = true
    
    // Variable to hold the current view controller
    var currentViewControllerOption: DMMainViewControllerOption = .Home
    
    // Variables to hold the naviation view controllers that both the panel and main view
    // view controllers are embedded in, the panel navigation controller is an optional because
    // the panel itself goes in and out of existence entirely
    var currentMainNavigationController: UINavigationController!
    var currentPanelNavigationController: UINavigationController?
    
    // Variable to hold the main view controller
    var mainViewController: DMMainViewController! {
        didSet {
            mainViewController.mainDelegate = self
        }
    }
    
    // An optional variable which will hold the panel view controller when it is visible
    var panelViewController: DMSidePanelTableViewController? {
        didSet {
            panelViewController?.panelDelegate = self
        }
    }
    
    // Constant to determine the amount of expansion of the side panel
    let panelExpandedOffsetPercent: CGFloat = 0.4
    
    var panelExpandedOffset: CGFloat {
        return panelExpandedOffsetPercent * currentMainNavigationController.view.frame.width
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting the main view controller
        mainViewController = UIStoryboard.viewControllerForOption(currentViewControllerOption)
        
        // Wrapping the main view controller into the navigation view controller
        currentMainNavigationController =
            UINavigationController(rootViewController: mainViewController)
        
        // Adding the main navigation controller as a child of the container
        view.addSubview(currentMainNavigationController.view)
        addChildViewController(currentMainNavigationController)
        currentMainNavigationController.didMoveToParentViewController(self)
    }
    
    func changeMainViewController(optionSelected: DMMainViewControllerOption) {
        self.mainViewController = UIStoryboard.viewControllerForOption(optionSelected)
        // Removing the old navigation controller with the embeded main view controller from the
        // container's children
        self.currentMainNavigationController.willMoveToParentViewController(nil)
        self.currentMainNavigationController.view.removeFromSuperview()
        self.currentMainNavigationController.removeFromParentViewController()
        self.currentMainNavigationController =
            UINavigationController(rootViewController: self.mainViewController)
        self.currentMainNavigationController.view.frame.origin.x =
            CGRectGetWidth(currentMainNavigationController.view.frame) - panelExpandedOffset
        self.view.addSubview(self.currentMainNavigationController.view)
        self.addChildViewController(self.currentMainNavigationController)
        togglePanel()
    }
    
    // The function togglePanel which takes a completion clsure to perform an operation after the
    // the panel has been fully animated
    func togglePanel() {
        // If the panel is closed, add the panel view controller
        if panelClosed {
            addPanelViewController()
        }
        
        // Animate the panel's slide in or out
        animatePanel(shouldExpand: panelClosed)
    }
    
    // Function to add a panel view controller
    func addPanelViewController() {
        // If the panel view controller is nil, create one and add it as a child
        if panelViewController == nil {
            panelViewController = UIStoryboard.panelViewController()
            currentPanelNavigationController =
                UINavigationController(rootViewController: panelViewController!)
            addChildSidePanelViewController(currentPanelNavigationController!)
        }
    }
    
    func addChildSidePanelViewController(childViewController: UINavigationController) {
        // Adding the child view controller's view as a subview (index 0 being below the main view
        // controller)
        view.insertSubview(childViewController.view, atIndex: 0)
        
        // Setting the view controller as a child view controller and setting self as the parent
        addChildViewController(childViewController)
        childViewController.didMoveToParentViewController(self)
    }
    
    func animatePanel(shouldExpand shouldExpand: Bool) {
        // If the panel should expand, expand it from the left, otherwise retract it to the right
        if (shouldExpand) {
            panelClosed = false
            
            // Calls the animation to be performed, the parentViewController is the Navigation
            // controller the main controller is embedded in.  Target position is accordint to the
            // constants
            animateCenterPanelXPosition(targetPosition:
                CGRectGetWidth(currentMainNavigationController.view.frame) - panelExpandedOffset)
        } else {
            // Same as with expansion, but targer position is now 0 (left of plane)
            animateCenterPanelXPosition(targetPosition: 0) {
                finished in
                self.panelClosed = true
                
                // Removing the panel view contrller from the view and making it nil to save memory
                self.currentPanelNavigationController!.willMoveToParentViewController(nil)
                self.currentPanelNavigationController!.view.removeFromSuperview()
                self.currentPanelNavigationController!.removeFromParentViewController()
                self.panelViewController = nil
                self.currentPanelNavigationController = nil
            }
        }
    }
    
    // Function that performs the actual animation, with all of the specifics of the animation
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat,
        completion: ((Bool) -> Void)! = nil) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                    self.currentMainNavigationController.view.frame.origin.x = targetPosition
                }, completion: completion)
    }
}

// Extending UIStoryboard for more programatic functionality, will be able to get the appropriate
// view controller entities by their respective identifiers
extension UIStoryboard {
    // Function to get the main storyboard for the app from the UIStoryboard class
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    // Function to get the panel view controller from the UIStoryboard class
    class func panelViewController() -> DMSidePanelTableViewController? {
        return mainStoryboard()
            .instantiateViewControllerWithIdentifier("DMSidePanelTableViewController")
            as? DMSidePanelTableViewController
    }
    
    // Function to get the main view controller from the UIStoryboard class
    class func viewControllerForOption(selectedOption: DMMainViewControllerOption)
        -> DMMainViewController {
        return mainStoryboard()
            .instantiateViewControllerWithIdentifier(selectedOption.controllerName)
            as! DMMainViewController
    }
}

