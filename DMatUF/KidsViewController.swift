//
//  KidsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/25/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

//
//  KidsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/13/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import Foundation

// Cell
class KidsCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}







class KidsViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Get array of kids from plist file
    var array: NSArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Kids", ofType: "plist")!)!
    
    var namesArray: Array<String> = []
    var thumbsArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateArrays()
    }
    
    func generateArrays() {
        for dict in array{
            if let name: String? = dict["name"] as String?{
                self.namesArray.append(name!)
            }
            if let thumb: String? = dict["image"] as String?{
                self.thumbsArray.append(thumb!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KidCellID", forIndexPath: indexPath) as KidsCell
            
            // Set cell background color
            cell.backgroundColor = UIColor(hue: CGFloat(CGFloat(indexPath.row) / CGFloat(array.count)), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
            cell.cellLabel.text = self.namesArray[indexPath.row]
            cell.cellImage.image = UIImage(named: self.thumbsArray[indexPath.row]) ?? UIImage(named: "ImageNotFound")
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var size = CGFloat(96.0)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                size = (view.frame.width - 12.0) / 3.0
            }
            
            return CGSize(width: size, height: size)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "KidDetailSegue"){
            let cell = sender as KidsCell
            var destination = segue.destinationViewController as KidDetailViewController
            
            
            if let index = collectionView?.indexPathForCell(cell) {
                println(index.row)
                
                if let dict = array.objectAtIndex(index.row) as? Dictionary<String, AnyObject> {
                    println(dict)
                    destination.kid = Kid(dict: dict)
                }
            }
        }
    }
}