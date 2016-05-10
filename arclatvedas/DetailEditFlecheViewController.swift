//
//  DetailEditFlecheViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreDataProxy


class DetailEditFlecheViewController: UIViewController {

    var context : AnyObject?

    
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var taille: UITextField!
    @IBOutlet weak var spin: UITextField!
    @IBOutlet weak var plume: UITextField!
    @IBOutlet weak var pointe: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var commentaire:UITextView!

    
    
    

//    comment
//    feather
//    length
//    name
//    point
//    spin
//    timeStamp
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(DetailEditFlecheViewController.saveObject(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
        self.configureView()
        
    }

    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            
            if let textename = self.nom {
                textename.text = detail.valueForKey("name")!.description
            }
            
            if let textetaille = self.taille {
                 //double
                textetaille.text = detail.valueForKey("length")!.description
            }
            
            if let textespin = self.spin {
               //int16
                textespin.text = detail.valueForKey("spin")!.description
            }
            if let texteplume = self.plume {
                texteplume.text = detail.valueForKey("feather")!.description
            }
            
            if let textepointe = self.pointe {
                textepointe.text = detail.valueForKey("point")!.description
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

        }
    }
    

    
    func saveObject(sender: AnyObject) {
        if let detail: AnyObject = self.detailItem {
            
            
            let dateFormat:NSDateFormatter = NSDateFormatter()
            dateFormat.dateFormat="dd/MM/yy"
            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
            let ladate :NSDate = dateFormat.dateFromString(self.date.text!)!
            
            detail.setValue(ladate, forKey: "timeStamp")
           

            
            detail.setValue(self.nom.text, forKey: "name")
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
            
            if let number = formatter.numberFromString(self.taille.text!) {
                detail.setValue(number, forKey: "length")
            }
            detail.setValue( NSNumber(integer: Int(self.spin.text!)!), forKey: "spin")
            
            detail.setValue(self.plume.text, forKey: "feather")
            detail.setValue(self.pointe.text, forKey: "point")

            detail.setValue(self.commentaire.text, forKey: "comment")

            
            DataManager.saveManagedContext()
            
            
//            if let cont:AnyObject = self.context {
//                var error: NSError? = nil
//                if !cont.save(&error) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    //println("Unresolved error \(error), \(error.userInfo)")
//                    abort()
//                }
//                
//            }
            
        }
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

}
