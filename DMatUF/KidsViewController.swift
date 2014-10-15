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



// Kid Class: so attributes can be easily accessed
class Kid {
    var name: String?
    var age: NSDate?
    var story: String?
    var image: UIImage?
    
    convenience init(dict: NSDictionary) {
        self.init()
        name = Optional(dict.objectForKey("name")! as? String)!
        age = Optional(dict.objectForKey("age")! as? NSDate)!
        story = Optional(dict.objectForKey("story")! as? String)!
        image = Optional(UIImage(named: Optional(dict.objectForKey("image")! as String)!))
    
    }
}



class KidsViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Get array of kids from plist file
    var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Kids", ofType: "plist")!)
    
    var namesArray: Array<String> = []
    var thumbsArray: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        generateArrays()
    }
    
    func generateArrays(){
        for dict in self.array{
            if let name: String? = dict["name"] as String?{
                self.namesArray.append(name!)
            }
            if let thumb: String? = dict["thumb"] as String?{
                self.thumbsArray.append(thumb!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    

    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KidsCellID", forIndexPath: indexPath) as KidsCell
            
            // Set cell background color
            cell.backgroundColor = UIColor(hue: CGFloat(CGFloat(indexPath.row) / CGFloat(self.array.count)), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
            cell.cellLabel.text = self.namesArray[indexPath.row]
            cell.cellImage.image = UIImage(named: self.thumbsArray[indexPath.row])
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
                
                let kid = Kid(dict: self.array[index] as NSDictionary)
                if let name = kid.name { destination.name = name }
                if let age = kid.age { destination.age = age }
                if let story = kid.story { destination.story = story }
                if let image = kid.image { destination.image = image }
          
            }
        }
    }
}