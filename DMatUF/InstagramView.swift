//
//  InstagramView.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/27/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit


// Cell
class InstagramCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}


class InstagramView: UIView {
    
    
    
//    convenience override init() {
//        self.init()
//        backgroundColor = UIColor.yellowColor()
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.yellowColor()
//    }

//    override convenience init() {
//        self.init(frame: super.frame)
////        frame = super.frame
//        backgroundColor = UIColor.purpleColor()
//    }
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    
//    
//    func collectionView(collectionView: UICollectionView,
//        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//            
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InstagramCellID", forIndexPath: indexPath) as SocialCell
//            
//            
//          
//            return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    }
//    
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            
//            return CGSize(width: 128, height: 128)
//    }
//    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "InstagramDetailSegue"){
//            let cell = sender as KidsCell
//            var destination = segue.destinationViewController as KidDetailViewController
////            
////            
////            if let index = collectionView.indexPathForCell(cell) {
////                println(index.row)
////                
////                if let dict = array.objectAtIndex(index.row) as? Dictionary<String, AnyObject> {
////                    println(dict)
////                    destination.kid = Kid(dict: dict)
////                }
////            }
//        }
//    }
//
}