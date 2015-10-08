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
import CoreData

class KidsViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()
    
    var selectedKid: Kid?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = getFetchedResultController()
        fetchedResultsController.delegate = self
        let _ = try? fetchedResultsController.performFetch()

        if fetchedResultsController.fetchedObjects?.count == 0 {
            createKids()
            let _ = try? fetchedResultsController.performFetch()
            collectionView?.reloadData()
        }
        
        // Google Analytics
        GA.sendScreenView(name: "KidsView")

        view.backgroundColor = Color.tvcEven

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
    }

    
    func createKids() {
        
        let array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Kids", ofType: "plist")!) as! [[String: AnyObject]]

        for kid in array {
            let newKid: Kid = NSEntityDescription.insertNewObjectForEntityForName("Kid", inManagedObjectContext: self.managedObjectContext) as! Kid
            newKid.name = kid["name"] as! String
            newKid.story = kid["story"] as! String
            newKid.image = kid["image"] as! String
            newKid.ageYear = kid["ageYear"] as! Int
            newKid.milestone = kid["milestone"] as? String

        }
    }

    
    func getFetchedResultController() -> NSFetchedResultsController {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: kidsFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func kidsFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Kid")
        let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        fetchRequest.fetchBatchSize = 1000
        fetchRequest.fetchLimit = 1000
        return fetchRequest
    }

    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    

    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KidCellID", forIndexPath: indexPath) as! KidsCell
            
            let kid = fetchedResultsController.objectAtIndexPath(indexPath) as! Kid

            
            cell.backgroundColor = UIColor.clearColor()
            cell.cellLabel.text = kid.name ?? ""
            cell.cellLabel.adjustsFontSizeToFitWidth = true
            cell.cellImage.image = UIImage(named: kid.image) ?? UIImage(named: "ImageNotFound")

            return cell
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let kid = fetchedResultsController.objectAtIndexPath(indexPath) as! Kid
        if kid.story != "" || kid.milestone != nil {
            selectedKid = fetchedResultsController.objectAtIndexPath(indexPath) as? Kid
            performSegueWithIdentifier("KidDetailSegue", sender: self)
        } else {
            UIAlertView.errorMessage("Sorry!", message: "No story available!")
        }
    }
    
    @IBAction func kinteraButtonPressed(sender: UIBarButtonItem) {
        GA.sendEvent(category: GA.K.CAT.BUTTON, action: GA.K.ACT.PRESSED, label: "kinteraButton", value: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("userInfo") as? [String: AnyObject] != nil {
            performSegueWithIdentifier("FundSegue", sender: self)
        } else {
            loginAlert()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "KidDetailSegue" {
                let destination = segue.destinationViewController as! KidDetailViewController
                destination.kid = selectedKid
        }
    }
}