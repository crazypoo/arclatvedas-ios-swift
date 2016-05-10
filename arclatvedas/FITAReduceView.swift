//
//  FITAReduceView.swift
//  arclatvedas
//
//  Created by divol on 31/07/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit


class FITAReduceView: BlasonView {
    
    override var nombrezone:Int {
        return 6
    }
    
    override var scores:[Int] {
        return [100,10,9,8,7,6,5]
    }

    
    override var colors:[UIColor] {
        return [UIColor.yellowColor(),UIColor.yellowColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.redColor(),UIColor.blueColor(),UIColor.blueColor()]
    }
    
   override var colorslines:[UIColor] { return [UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor()]}

}