//
//  InterfaceController.swift
//  arcLatVedas WatchKit Extension
//
//  Created by divol on 21/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var imageicone: WKInterfaceImage!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
//        var dico: Dictionary<String, String> = ["AAPL" : "Apple Inc", "GOOG" : "Google Inc", "AMZN" : "Amazon.com, Inc", "FB" : "Facebook Inc"]

        
        InterfaceController.openParentApplication(["request": "refreshData"],
            reply: { (replyInfo, error) -> Void in
                // TODO: process reply data
                NSLog("Reply: \(replyInfo)")
                
                
                if let response = replyInfo["response"] as? NSData {
                    if let str = NSKeyedUnarchiver.unarchiveObjectWithData(response) as? String {
                            NSLog("response: \(str)")
                    }
                }

        })
    
    
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
