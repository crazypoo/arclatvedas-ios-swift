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
import CoreData
class DetailEditMaterielViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var matos: UITextField!
    @IBOutlet weak var serialnumber: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var commentaire:UITextView!
    @IBOutlet weak var viewimage:UIImageView!
    
    
    var newMedia: Bool?
    
    var context : AnyObject?
    
    var patha:String?=nil
    
    var imageManager:PHImageManager = PHImageManager.default();
    
    var imageframe:CGRect?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let singleTap = UITapGestureRecognizer(target: self, action:#selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        
        imageframe = viewimage.frame;
        viewimage.isUserInteractionEnabled = true
        viewimage.addGestureRecognizer(singleTap)
        
        
        
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailEditMaterielViewController.saveObject(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
          self.configureView()
    }

    
    func tapDetected() {
        
        let theframe:CGRect?
        let small = (viewimage.frame == imageframe)
        if (small){
            
            
            let mtop = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height

            
            
            var taille: CGFloat = min(self.view.frame.size.width, self.view.frame.size.height)
            if taille == self.view.frame.size.height {
                taille -= mtop
            }
            
            
            theframe = CGRect(x: 0,y: mtop, width: taille, height: taille)
        }else{
            theframe = imageframe!

        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
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
        if let detail: NSManagedObject = self.detailItem  as? NSManagedObject{
            
           // self.navigationItem.title = ""
            var value : String
            if let textename = self.matos {
                 value = detail.value(forKey: "name") as! String
                textename.text = value
            }
            
            if let texteserialnumber = self.serialnumber {
                value = detail.value(forKey: "serialnumber") as! String
                texteserialnumber.text = value
            }
            
            if let textedate = self.date {
                
                let dateFormat:DateFormatter = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                dateFormat.dateFormat="dd/MM/yy"
                let ladate:Date  = detail.value(forKey: "timeStamp") as! Date
                
                
                let dateString:String = dateFormat.string(from: ladate)
                
                textedate.text = dateString
            }
            
            if let textecommentaire = self.commentaire {
                value = detail.value(forKey: "comment") as! String
                textecommentaire.text = value
            }
            
            if let texteimage = self.viewimage {
                let path = (detail.value(forKey: "imagepath")! as AnyObject).description
                if !(path?.isEmpty)! {
                    
                    
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
                    
                    var aurl = URL(string:path!)
                    
                    
                    
                    
                 //   ALAssetsLibraryAssetForURLResultBlock
                    
                    library.asset( for: aurl, resultBlock: {(asset) -> Void in
                        let representation = asset?.defaultRepresentation()
                        let imageRef = representation?.fullResolutionImage().takeUnretainedValue()
                        
                            texteimage.image = UIImage(cgImage: imageRef!)
                        
                        
                    }, failureBlock:nil)
                    
                   
                }
            }
            //
        }
    }

    
    
    
    func saveObject(_ sender: AnyObject) {
    if let detail: AnyObject = self.detailItem {
        

        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateStyle = DateFormatter.Style.short
        dateFormat.dateFormat="dd/MM/yy"
        let ladate :Date = dateFormat.date(from: self.date.text!)!
        
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
    
    
    
    @IBAction func useCamera(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.camera)
            {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, 
                    completion: nil)
                newMedia = true
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        if mediaType == kUTTypeImage as String {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            viewimage.image = image
            self.patha=nil;
            if (newMedia == true) {
                let library:ALAssetsLibrary = ALAssetsLibrary()
               
                library.writeImage(toSavedPhotosAlbum: image.cgImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock: { (path,err) -> Void in
                     self.patha = path?.description
                })
                
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                    "image:didFinishSavingWithError:contextInfo:", nil)
                
                
            } else if mediaType == kUTTypeMovie as String {
                // Code to support video here
            }
            
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
