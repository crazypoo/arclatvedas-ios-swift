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
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
    
        location.setText("")
        distance.setText("")
        total.setText("")
        date.setText("")
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            
            NSLog("\(titi.getTotal())")
            
            let dateFormat:NSDateFormatter = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormat.dateFormat="dd/MM/yy"
            let dateString:String = dateFormat.stringFromDate(titi.timeStamp)
            
            
            location.setText(titi.location)
            distance.setText(titi.distance)
            total.setText("\(titi.getTotal())")
            date.setText(dateString)

        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
