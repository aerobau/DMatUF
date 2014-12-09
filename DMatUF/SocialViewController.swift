//
//  ViewController.swift
//  Collection Demo
//
//  Created by Mick on 10/13/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

import UIKit

class SocialCell: UICollectionViewCell {
    // stuff
}

class SocialViewController: UICollectionViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var segment: UISegmentedControl!

    
//    let page: Array<UIView> = [InstagramView()]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Use this if you want to define the prototype in code instead of IB
//        collectionView.registerClass(SocialCell.self, forCellWithReuseIdentifier: "theCellID")
    }

    @IBAction func segmentChangedValue(sender: UISegmentedControl) {
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: sender.selectedSegmentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    
    }
    
    
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segment.numberOfSegments
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SocialCellID", forIndexPath: indexPath) as SocialCell

        cell.backgroundColor = UIColor(hue: CGFloat(indexPath.row) / 4.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
        cell.addSubview(InstagramView())
        // Need to make the cell filled with the view
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width -
            collectionView.contentInset.left -
            collectionView.contentInset.right,
            height: collectionView.bounds.size.height -
                collectionView.contentInset.top -
                collectionView.contentInset.bottom)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetCenter = CGPoint(x: targetContentOffset.memory.x - scrollView.contentInset.left + scrollView.center.x,
            y: scrollView.center.y)
        
        if let row = self.collectionView?.indexPathForItemAtPoint(offsetCenter)?.item {
            segment.selectedSegmentIndex = row
        }
    }
}

