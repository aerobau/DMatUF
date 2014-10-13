//
//  KidsViewController.swift
//  DMatUF
//
//  Created by Ian MacCallum on 10/13/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import UIKit
class KidsCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    // stuff
}

class KidsViewController: UICollectionViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func generateArray(){
        let path = NSBundle.mainBundle().pathForResource("Kids", ofType:"plist")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        // Needs to be number of items in plist array
    }

    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KidsCellID", forIndexPath: indexPath) as KidsCell
            
            cell.backgroundColor = UIColor(hue: CGFloat(indexPath.row) / 4.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            cell.cellLabel.text = "John"
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
    
}

    

