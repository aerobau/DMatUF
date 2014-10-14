//
//  KidsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/13/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
import Foundation

class KidsCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    // stuff
}

class Kid {
    
    var name: String?
    var age: NSDate?
    var story: String?
    var image: UIImage?
    
    convenience init(array: NSArray, index: Int) {
        self.init()
        
        name = Optional(array[index].objectForKey("name")! as? String)!
        age = Optional(array[index].objectForKey("age")! as? NSDate)!
        story = Optional(array[index].objectForKey("story")! as? String)!
        image = Optional(UIImage(named: Optional(array[index].objectForKey("image")! as String)!))
    }
}

class KidsViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Kids", ofType: "plist")!)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
        // Needs to be number of items in plist array
    }
    

    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KidsCellID", forIndexPath: indexPath) as KidsCell
            
            cell.backgroundColor = UIColor(hue: CGFloat(indexPath.row) / 4.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
            let kid = Kid(array: self.array, index: indexPath.row)
            cell.cellLabel.text = kid.name
            cell.cellImage.image = kid.image
            
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: 128, height: 128)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "KidStorySegue"){
            let cell = sender as KidsCell
            var destination = segue.destinationViewController as KidStoryViewController
            
            
            if let index = self.collectionView?.indexPathForCell(cell)!.row{
                destination.index = index
                
                let kid = Kid(array: self.array, index: index)
                
                if let name = kid.name { destination.name = name }
                if let age = kid.age { destination.age = age }
                if let story = kid.story { destination.story = story }
                if let image = kid.image { destination.image = image }
                
                

                
            }
        }
    }
    
}