//
//  ViewController.swift
//  cropcircles
//
//  Created by divol on 26/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import CoreDataProxy

class TargetController: UIViewController,DCDMagnifyingGlassViewDelegate {
    var magnifyingView: DCDMagnifyingGlassView?
    var magnifyingViewVisible:Bool=false
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    var cv:CircleView?
    var iv: ImpactView?
    
    
    let NOMBREMAX : Int = 6
    var curVolee:Volee?
    var curCount:Int = -1

    
    
    @IBOutlet weak var totalLabel : UILabel!
    @IBOutlet weak var voleeLabel : UILabel!


    
    var detailItem: Tir? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    override func loadView() {
        super.loadView()
        let r = self.view.frame
        let cote = min(self.view.frame.size.width,self.view.frame.size.height)
        let rect = CGRect(x: 0 ,y: 100 ,width: cote, height:cote)
        cv = CircleView(frame: rect)
        magnifyingViewVisible=false
        
        //Set up gesture recognizer
        
        tapGestureRecognizer.addTarget(self, action: "tapAction:")
        tapGestureRecognizer.enabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(cv!)
        
        self.iv = ImpactView(frame: rect)
        //        self.iv!.addPoint(CGPointMake(50,50))
        //        self.iv!.addPoint(CGPointMake(100,100))
        self.view.addSubview(self.iv!)
        
        
        
        DCDMagnifyingGlassView.setTargetView(self.view)
        DCDMagnifyingGlassView.setScale(5)
        DCDMagnifyingGlassView.setContentFrame(CGRect(x: 115,y: 90,width: 100,height: 100))
        DCDMagnifyingGlassView.setIndicatorColor(UIColor.greenColor())
        DCDMagnifyingGlassView.setShadowColor(UIColor.redColor())
        DCDMagnifyingGlassView.sharedInstance.glassDelegate=self
        
        
        
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        
        magnifyingViewVisible = !magnifyingViewVisible
        
        let pt1:CGPoint = sender.locationOfTouch(0,inView: self.view)
        let pt2:CGPoint = sender.locationOfTouch(0,inView: self.iv)
        
        //pour etre sous le doigt
        DCDMagnifyingGlassView.setContentFrame(CGRect(x: pt1.x-50,y: pt1.y-50,width: 100,height: 100))
        
        if  magnifyingViewVisible  {
            DCDMagnifyingGlassView.show(true)
        } else {
            DCDMagnifyingGlassView.dismiss(true)
        }
        
        
        
        
        
    }
    
    func managePanBegin(sender: UIPanGestureRecognizer){
        
    }
    func managePanEnd(sender: UIPanGestureRecognizer){
        
        let pt2 = DCDMagnifyingGlassView.sharedInstance.indicatorView.center
        
        let pt3 = self.iv?.convertPoint(pt2, fromView: DCDMagnifyingGlassView.sharedInstance.indicatorView)
        let point = CGPointMake(pt3!.x-40,pt3!.y-40)
       
        
        
        
        
        let score = cv!.getScoreForPoint(point)
        
        
        if   curVolee!.addScore(score, impact:point) {
            self.iv!.addPoint(point)

        }
        
        
        saveObject(self)

        refreshVoleeLabel()
        DCDMagnifyingGlassView.dismiss(true)
        magnifyingViewVisible=false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func pressed(sender: UIButton!) {
        
        switch sender.tag {
        case 1000 :
            
            if curVolee!.deleteLast() {
                 self.iv!.removePoint()
            }
            
            saveObject(self)
            refreshVoleeLabel()
            break
            
            
        case 2000 :
            if let vol: Volee = self.curVolee {
                if ((vol.getTaille() == NOMBREMAX)  || (vol.getTaille() == 3)) {
                    
                    saveObject(self)
                    
                    curVolee = createEmptyVolee()
                    
                    saveObject(self)
                    
                    if let detail: Tir = self.detailItem {
                        
                        curCount =  detail.volees.count-1
                    }
                    
                }
            }
            if self.detailItem!.volees.count == 0 {
                curVolee = createEmptyVolee()
                
                saveObject(self)
                
                curCount=0
                
            }
            refreshVoleeLabel()
//        case 3000 :
//            UIView.transitionWithView(self.statview, duration: 0.325, options: .TransitionFlipFromLeft | .CurveEaseInOut, animations: { () -> Void in
//                if  self.statview.alpha == 0.0 {
//                    if let detail: Tir = self.detailItem {
//                        
//                        if detail.volees.count > 1 {
//                            self.buildChart()
//                            self.statview.alpha=1.0
//                            self.tableview.alpha=0.0
//                        }
//                        
//                    }
//                }else{
//                    self.statview.alpha=0.0
//                    self.tableview.alpha=1.0
//                }
//                
//                }, completion: { (Bool) -> Void in
//                    
//            })
            
            
        default :
             saveObject(self)

        }
        
    }
    
    
    
    func createEmptyVolee() -> Volee {
        
        
        
        
        let entityDescription = NSEntityDescription.entityForName("Volee", inManagedObjectContext: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
        
        volee.setValue("[]", forKey: "volee")
        volee.setValue(detailItem!, forKey: "relationship")
        volee.setValue(0 ,forKey: "rang")
        
        
        
        detailItem!.volees.addObject(volee)
        
        return volee
    }

    
    
    func refreshVoleeLabel(){
        voleeLabel?.text = ""
        var str = ""
        
        for (var i = 0 ; i < NOMBREMAX ; i++){
            //une constante pour le 6 !!
            let points:Int = curVolee!.getAt(i)
            if points >= 0 {
                
                if points == 100 {
                    str += "X"
                }else  if points == 0 {
                    str += "M"
                    
                } else {
                    str += points.description
                }
                
                if i < NOMBREMAX-1 {
                    str += "-"
                }
                
            }else{
                 str += "*"
            }
            
            
            
        }
        voleeLabel?.text = str

        
    }
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Tir = self.detailItem {
            self.navigationItem.title = detail.location + ":" + detail.distance
            
            totalLabel?.text = detail.getTotal().description
            
            
            
            
            if let detail: Tir = self.detailItem {
                if detail.volees.count > 0 {
                    
                    
                    self.curVolee = detail.volees.lastObject as! Volee
                    curCount = detail.volees.count-1
                }else{
                    curVolee = createEmptyVolee()
                    saveObject(self)
                    curCount = 0
                }

                refreshVoleeLabel()
                
            }
        }
    }
    
    func editObject (sender: AnyObject) {
        if let detail: Tir = self.detailItem {
            var alert = UIAlertController(title: "Edit", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                
                var texts = alert.textFields as! [UITextField]
                for (var i = 0 ; i < texts.count ; i++){
                    
                    let textField: UITextField = texts[i]
                    if textField.placeholder == "Localication:" {
                        
                        if let detail: Tir = self.detailItem {
                            
                            detail.setValue(textField.text, forKey: "location")
                        }
                        
                    }else {
                        detail.setValue(textField.text, forKey: "distance")
                        
                    }
                    
                }
                self.saveObject(self)
                self.navigationItem.title = detail.location + ":" + detail.distance
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!)  in
                textField.placeholder = "Localication:"
                textField.secureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                    textField.text = detail.location
                }
            })
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!)  in
                textField.placeholder = "Distance:"
                textField.keyboardType = .DecimalPad
                textField.secureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                    textField.text = detail.distance
                }
                
            })
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func saveObject(sender: AnyObject) {
        if let detail: Tir = self.detailItem {
            
            
            self.view.resignFirstResponder()
            
            //            let dateFormat:NSDateFormatter = NSDateFormatter()
            //            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
            //            dateFormat.dateFormat="dd-MM-yy"
            //            let ladate :NSDate = dateFormat.dateFromString("")!
            //
            
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
            
            if let detail: Tir = self.detailItem {
                totalLabel?.text = detail.getTotal().description
            }
            
        }
    }

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editObject:")
        self.navigationItem.rightBarButtonItem = editButton
        
        
        
        if let detail: Tir = self.detailItem {
            if detail.volees.count > 0 {
                
                for (var i = 0 ; i <  detail.volees.count ; i++){
                    let vol :Volee = detail.volees.objectAtIndex(i) as! Volee
                    
                    for (var i = 0 ; i < NOMBREMAX ; i++){
                        //une constante pour le 6 !!
                        let points:Int = vol.getAt(i)
                    
                        if points >= 0 {
                            let coord = vol.getImpactAt(i)
                            
                            if coord.x != 0 || coord.y != 0 {
                                self.iv!.addPoint(coord)
                            }

                            
                            
                        }
                        
                        
                        
                    }

                    
                    
                    
                    
                }
            }
        
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



