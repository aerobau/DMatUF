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
    // stuff
}

class kid: NSDictionary {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let name: AnyObject? = self["name"]
        
        
    }
}

class KidsViewController: UICollectionViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Kids", ofType: "plist")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.array.description)
        downloadImages()
    }
    
    
    func downloadImages(){
        for dict in self.array {
            if let data: NSData? = Optional(dict["image"] as? NSData) {
                if let image: UIImage? = Optional(UIImage(data: data!)){
                    println("Theres an image")
                    println(data!.description)
                }else{
                    println("Theres NO image")
                }
            }else{
                println("nil")
            }
        }
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
            
            println()
            if let name: String? =  Optional(self.array[indexPath.row].objectForKey("name")! as? String){
                cell.cellLabel.text = name
            }
            
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: 64, height: 64)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "KidStorySegue"){
            let cell = sender as KidsCell
            var destination = segue.destinationViewController as KidStoryViewController
            
            let index = self.collectionView?.indexPathForCell(cell)!.row
            destination.index = index
            destination.name = Optional(self.array[index!].objectForKey("name")! as? String)!
        }
    }
    
}

    

