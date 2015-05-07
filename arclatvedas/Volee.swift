//
//  Volee.swift
//  
//
//  Created by divol on 29/04/2015.
//
// https://github.com/SwiftyJSON/SwiftyJSON

import Foundation
import CoreData

@objc(Volee)

class Volee: NSManagedObject {

    
   @NSManaged var volee: String
   @NSManaged var rang: NSNumber
   @NSManaged var relationship: Tir

    let NOMBREMAX : Int = 6
    
    var scores:NSMutableArray {
    
        get {
            
            if  volee.isEmpty {
                self.volee = "[]"
            }
            var json:JSON = JSON(data:self.volee.dataUsingEncoding(NSUTF8StringEncoding)!);
    
            //
            let toto = json.arrayObject
    
             let ascores = NSMutableArray(array: toto!)
            return ascores
             

        }
    }
    
    
    
    func getTotal() -> Int {
        var res:Int = 0
        let copyscore = scores
            
                 for var i = 0 ; i < copyscore.count ; i++ {
                     let num:NSNumber = copyscore.objectAtIndex(i) as! NSNumber
                    if  num.integerValue == 100 {
                        res  = res + 10
                    }else {
                        res  = res + num.integerValue
                    }
                 }
            
        
        return res
    }
    
    func addScore (points : Int) {
        
        let copyscore = self.scores

        if copyscore.count < NOMBREMAX {
            copyscore.addObject(NSNumber(integer: points))
        }
        
        
        let data:NSData =  NSJSONSerialization.dataWithJSONObject(copyscore,options: NSJSONWritingOptions(0), error: nil)!
        
        self.volee = NSString(data: data, encoding: NSUTF8StringEncoding)!.description
        
    }
    
    func deleteLast(){
        
        let copyscore = scores

        if copyscore.count != 0 {
            copyscore.removeLastObject()
        }
        
        let data:NSData =  NSJSONSerialization.dataWithJSONObject(copyscore,options: NSJSONWritingOptions(0), error: nil)!
        
        self.volee = NSString(data: data, encoding: NSUTF8StringEncoding)!.description

    }
    
    func getAt(fleche : Int) -> Int{
        var res:Int = -1
        let copyscore = scores
        
        if fleche < copyscore.count {
            let num:NSNumber = copyscore.objectAtIndex(fleche) as! NSNumber
            res = num.integerValue
        }
        
        return res
    }
    func getTaille()->Int{
         let copyscore = self.scores
        return copyscore.count
    }
}
