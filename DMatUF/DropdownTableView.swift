//
//  EventsDropdownTableView.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/29/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit

protocol DropdownController {
    func dropdown(dropdown: DropdownTableView, didDismissWithIndexPath indexPath: NSIndexPath, andTitle title: String)
}

class DropdownCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        textLabel?.textAlignment = .Center
        
        tintColor = Color.primary1

        textLabel?.textColor = Color.primary1
    
        selectionStyle = .None

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class DropdownTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var isOpened = false
    var dropdownDelegate: DropdownController?
    var items = [String]()
    var checkedIndex = NSIndexPath(forRow: 0, inSection: 0)
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        dataSource = self
        delegate = self
        
        registerClass(DropdownCell.self, forCellReuseIdentifier: "CellID")
        
        backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        separatorStyle = .None
        userInteractionEnabled = true
        alwaysBounceVertical = false
        
        let tap = UITapGestureRecognizer(target: self, action: "hide")
        
        let bgView = UIView(frame: frame)
        bgView.backgroundColor = UIColor.clearColor()
        backgroundView = bgView
        backgroundView?.addGestureRecognizer(tap)
        
    }
    
    override func numberOfRowsInSection(section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        
        cell.textLabel?.font = indexPath == checkedIndex ? Font.subheader.fontWithSize(18) : Font.body1.fontWithSize(18)

        return cell
    }
    
    override func reloadData() {
        super.reloadData()
        
        dropdownDelegate?.dropdown(self, didDismissWithIndexPath: NSIndexPath(forRow: 0, inSection: 0), andTitle: items[0])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dropdownDelegate?.dropdown(self, didDismissWithIndexPath: indexPath, andTitle: items[indexPath.row])
        checkedIndex = indexPath
        deselectRowAtIndexPath(indexPath, animated: false)
        hide()
    }
    
    func hide() {
        removeFromSuperview()
        isOpened = false
    }
    
    func showInView(view: UIView, withFrame frame: CGRect) {
//        if contentOffset.y == 0 {
            reloadData()
            view.addSubview(self)
            self.frame = frame
            isOpened = true
//        }
    }
}