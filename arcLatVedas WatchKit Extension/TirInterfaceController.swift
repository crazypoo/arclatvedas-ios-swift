//
//  TirInterfaceController.swift
//  arclatvedas
//
//  Created by divol on 22/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation


import WatchKit
import Foundation
import CoreDataProxy

class TirInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
