//
//  FeedViewController.swift
//  PhotoExchange
//
//  Created by Rick Williams on 11/5/15.
//  Copyright (c) 2015 Rick Williams. All rights reserved.
//


import CoreData
import UIKit
import MobileCoreServices

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  
    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedArray: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = NSFetchRequest(entityName: "FeedItem")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        feedArray = context.executeFetchRequest(request, error: nil)!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // UICollectionViewDataSourse
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as FeedCell
        
        let thisItem = feedArray[indexPath.row] as FeedItem
        
        cell.imageView.image = UIImage(data: thisItem.image)
        cell.captionLabel.text = thisItem.caption
        
        return cell
    }
    
    //UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let thisItem = feedArray[indexPath.row] as FeedItem
        var filterVC = FilterViewController()
        filterVC.myFeedItem = thisItem
        
        self.navigationController?.pushViewController(filterVC, animated: false)
        
    }
    
    
    
    
    
    @IBAction func cameraSnapBtnTapped(sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            var cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            
            let mediaType:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaType;
            cameraController.allowsEditing = false;
            
            self.presentViewController(cameraController, animated: true, completion: nil);
            
        }
        else if
            UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                
                var photoLibraryController = UIImagePickerController()
                photoLibraryController.delegate = self;
                photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                
                let mediaTypes:[AnyObject] = [kUTTypeImage]
                photoLibraryController.mediaTypes = mediaTypes
                photoLibraryController.allowsEditing = false
                
                self.presentViewController(photoLibraryController, animated: true, completion: nil)
                
        }
        else{
            var alertController = UIAlertController(title: "Alert", message: "Your devise does not support the camera or photo Library ", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    //UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
        
        let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        feedItem.image = imageData
        feedItem.caption = "test caption"
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        
        feedArray.append(feedItem)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.collectionView.reloadData()
        
    }
    
}














