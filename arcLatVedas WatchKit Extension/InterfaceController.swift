//
//  InterfaceController.swift
//  arcLatVedas WatchKit Extension
//
//  Created by divol on 21/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import WatchKit
import Foundation
import CoreDataProxy

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var imageicone: WKInterfaceImage!
    @IBOutlet weak var location: WKInterfaceLabel!
    @IBOutlet weak var distance: WKInterfaceLabel!
    @IBOutlet weak var total: WKInterfaceLabel!
    @IBOutlet weak var date: WKInterfaceLabel!
    var curTir:Tir!
    
    
    override func awakeWithContext(context: AnyObject?) {
        
       
        super.awakeWithContext(context)

        
        
        location.setText("")
        distance.setText("")
        total.setText("")
        date.setText("")
        
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            curTir=titi
            
        }
        

    }

 override   func handleUserActivity(userInfo: [NSObject : AnyObject]?){

    
    
    
    // Assume the app delegate has a text field to display the activity information
    NSLog("watch user info %@", userInfo!);

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
            dispatch_async(dispatch_get_main_queue()) { // 2
                
                let dateFormat:NSDateFormatter = NSDateFormatter()
                dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
                dateFormat.dateFormat="dd/MM/yy"
                let dateString:String = dateFormat.stringFromDate(self.curTir.timeStamp)
                
                
                self.location.setText(self.curTir.location)
                self.distance.setText(self.curTir.distance)
                self.total.setText("\(self.curTir.getTotal())")
                self.date.setText(dateString)

            }
        }

        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}



// Configure interface objects here.

//        var dico: Dictionary<String, String> = ["AAPL" : "Apple Inc", "GOOG" : "Google Inc", "AMZN" : "Amazon.com, Inc", "FB" : "Facebook Inc"]


//        InterfaceController.openParentApplication(["request": "refreshData"],
//            reply: { (replyInfo, error) -> Void in
//                // TODO: process reply data
//                NSLog("Reply: \(replyInfo)")
//
//
//                if let response = replyInfo["response"] as? NSData {
//                    if let str = NSKeyedUnarchiver.unarchiveObjectWithData(response) as? String {
//                            NSLog("response: \(str)")
//                    }
//                }
//
//        })

