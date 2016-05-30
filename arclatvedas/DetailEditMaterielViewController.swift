//
//  DetailEditMaterielViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import MobileCoreServices
import UIKit
import AssetsLibrary
import Photos
import CoreDataProxy

class DetailEditMaterielViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var matos: UITextField!
    @IBOutlet weak var serialnumber: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var commentaire:UITextView!
    @IBOutlet weak var viewimage:UIImageView!
    
    
    var newMedia: Bool?
    
    var context : AnyObject?
    
    var patha:String?=nil
    
    var imageManager:PHImageManager = PHImageManager.defaultManager();
    
    var imageframe:CGRect?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let singleTap = UITapGestureRecognizer(target: self, action:#selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        
        imageframe = viewimage.frame;
        viewimage.userInteractionEnabled = true
        viewimage.addGestureRecognizer(singleTap)
        
        
        
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(DetailEditMaterielViewController.saveObject(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
          self.configureView()
    }

    
    func tapDetected() {
        
        let theframe:CGRect?
        let small = (viewimage.frame == imageframe)
        if (small){
            
            
            let mtop = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height

            
            
            var taille: CGFloat = min(self.view.frame.size.width, self.view.frame.size.height)
            if taille == self.view.frame.size.height {
                taille -= mtop
            }
            
            
            theframe = CGRectMake(0,mtop, taille, taille)
        }else{
            theframe = imageframe!

        }
        
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                  self.viewimage.frame = theframe!
            
            }, completion: { finished in
                
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    
    
    
    
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            
           // self.navigationItem.title = ""
            
            if let textename = self.matos {
                textename.text = detail.valueForKey("name")!.description
            }
            
            if let texteserialnumber = self.serialnumber {
                texteserialnumber.text = detail.valueForKey("serialnumber")!.description
            }
            
            if let textedate = self.date {
                
                let dateFormat:NSDateFormatter = NSDateFormatter()
                dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
                dateFormat.dateFormat="dd/MM/yy"
                let ladate:NSDate  = detail.valueForKey("timeStamp") as! NSDate
                
                
                let dateString:String = dateFormat.stringFromDate(ladate)
                
                textedate.text = dateString
            }
            
            if let textecommentaire = self.commentaire {
                textecommentaire.text = detail.valueForKey("comment")!.description
            }
            
            if let texteimage = self.viewimage {
                let path = detail.valueForKey("imagepath")!.description
                if !path.isEmpty {
                    
                    
//                     let legacyAsset:PHAsset = PHAsset.fetchAssetsWithALAssetURLs([(NSURL(string: path)?)!],options:nil).firstObject
//                    
//                    let convertedIdentifier = legacyAsset.localIdentifier;
//                    
//                    
//                    var targetSize:CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
//                    var itemOptions = PHImageRequestOptions()
//                    itemOptions.networkAccessAllowed = true
//                    itemOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.PHImageRequestOptionsDeliveryModeHighQualityFormat;
//
//                    
// 
//                    imageManager.requestImageForAsset(legacyAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFit, options: itemOptions, resultHandler: { (result:UIImage?, info:[NSObject : AnyObject]?) -> Void in
//                        if result != nil  {
//                                texteimage.image = result
//                        }
//                        }
//                    )
                    
                    
                     let library:ALAssetsLibrary = ALAssetsLibrary()
                    library.assetForURL( NSURL(string: path), resultBlock: { (asset:ALAsset!) -> Void in
                        let representation = asset.defaultRepresentation()
                        let imageRef = representation.fullResolutionImage().takeUnretainedValue()
                        
                            texteimage.image = UIImage(CGImage: imageRef)
                        
                        
                    }, failureBlock:nil)
                    
                   
                }
            }
            //
        }
    }

    
    
    
    func saveObject(sender: AnyObject) {
    if let detail: AnyObject = self.detailItem {
        

        let dateFormat:NSDateFormatter = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.dateFormat="dd/MM/yy"
        let ladate :NSDate = dateFormat.dateFromString(self.date.text!)!
        
        detail.setValue(ladate, forKey: "timeStamp")
        detail.setValue(self.matos.text, forKey: "name")
        detail.setValue(self.serialnumber.text, forKey: "serialnumber")
        detail.setValue(self.commentaire.text, forKey: "comment")
        if self.patha != nil {
            detail.setValue(self.patha, forKey: "imagepath")
        }
        
        
        DataManager.saveManagedContext()
        
//        if let cont:AnyObject = self.context {
//            var error: NSError? = nil
//            if !cont.save(&error) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                //println("Unresolved error \(error), \(error.userInfo)")
//                abort()
//            }
//
//        }
        
        }
    }
    
    
    
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, 
                    completion: nil)
                newMedia = true
        }
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        if mediaType == kUTTypeImage as String {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            viewimage.image = image
            self.patha=nil;
            if (newMedia == true) {
                let library:ALAssetsLibrary = ALAssetsLibrary()
               
                library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock: { (path : NSURL!,err: NSError!) -> Void in
                     self.patha = path.description
                })
                
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                    "image:didFinishSavingWithError:contextInfo:", nil)
                
                
            } else if mediaType == kUTTypeMovie as String {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
