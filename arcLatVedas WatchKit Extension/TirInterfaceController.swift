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
import CoreData
import CoreDataProxy

//class TirInterfaceController: WKInterfaceController,NSUserActivityDelegate {
class TirInterfaceController: WKInterfaceController {
    @IBOutlet weak var voleeNumero: WKInterfaceLabel!
    @IBOutlet weak var total: WKInterfaceLabel!
    @IBOutlet weak var scorevolee: WKInterfaceLabel!
    
    var curTir:Tir?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            curTir=titi
            
             doRefresh()
            
        }

    }
    
    
    
    override   func handleUserActivity(userInfo: [NSObject : AnyObject]?){
        super.handleUserActivity(userInfo)
        
        
        
        
        // Assume the app delegate has a text field to display the activity information
      //  NSLog("handleUserActivity %@", userInfo!);
        
    }
    
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            curTir=titi
            
            doRefresh()
            
        }
        
        
    }

    
    func doRefresh(){
        
        if let tir = curTir {
            self.updateUserActivity("com.jack.arclatvedas.update", userInfo: ["key1": ["yo":"dawg"]], webpageURL: nil)

            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
                dispatch_async(dispatch_get_main_queue()) { // 2
                    
                    self.voleeNumero.setText("\(tir.volees.count)")
                    self.total.setText("\(tir.getTotal()) (0)")
                    if let vol:Volee = tir.volees.objectAtIndex(tir.volees.count-1) as? Volee {
                        self.scorevolee.setText(vol.description)
                        self.total.setText("\(tir.getTotal()) (\(vol.getTotal()))")
                    }

                }
            }

            
            

            
        }
        
    }
    
    @IBAction func doButtonX()
    {
        doButton(100)
    }
    @IBAction func doButton10()
    {
        doButton(10)
    }
    @IBAction func doButton9()
    {
        doButton(9)
    }
    @IBAction func doButton8()
    {
        doButton(8)
    }
    @IBAction func doButton7()
    {
         doButton(7)
    }
    @IBAction func doButton6()
    {
        doButton(6)
    }
    @IBAction func doButton5()
    {
        doButton(5)
    }
    @IBAction func doButton4()
    {
         doButton(4)
    }
    @IBAction func doButton3()
    {
         doButton(3)
    }
    @IBAction func doButton2()
    {
         doButton(2)
    }
    @IBAction func doButton1()
    {
        doButton(1)
    }
    @IBAction func doButton0()
    {
        doButton(0)
    }
    func doButton(what:Int)
    {
        
        if let tir = curTir {
            if let vol:Volee = tir.volees.objectAtIndex(tir.volees.count-1) as? Volee {
                
                vol.addScore(what, impact:CGPointMake(0,0),zone:CGPointMake(0,0))
            }
        }

        doRefresh()
         DataManager.saveManagedContext()
        

    }

    

    
    
    
    @IBAction func doButtonMoins()
    {
        
         if let tir = curTir {
            if let vol:Volee = tir.volees.objectAtIndex(tir.volees.count-1) as? Volee {
                
                vol.deleteLast()
            }
        }
        doRefresh()
         DataManager.saveManagedContext()
    }

    
    
    @IBAction func doMenuActionVoleeSuivante() {
        // Handle menu action.
        let wutils:WatchUtils = WatchUtils()
        if let tir = curTir {
            wutils.createEmptyVolee(tir)
        }
        doRefresh()
         DataManager.saveManagedContext()
    }
    

    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
