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

public class Volee: NSManagedObject {

    
   @NSManaged public var volee: String
   @NSManaged public var rang: NSNumber
   @NSManaged public var relationship: Tir

    let NOMBREMAX : Int = 6
    
public    var scores:NSMutableArray {
    
        get {
                if self.volee.isEmpty {
                    self.volee = "[]"
                }
            
            var json:JSON = JSON(data:self.volee.dataUsingEncoding(NSUTF8StringEncoding)!);
    
            //
            let toto = json.arrayObject
    
             let ascores = NSMutableArray(array: toto!)
            return ascores
             

        }
    }
    
    public  override var description:String{
        get {
            var result = ""
            if self.volee.isEmpty {
                return "-"
            }else{
                let copyscore = scores
                var chunk = ""
                for var i = 0 ; i < copyscore.count ; i++ {
                    let num:NSNumber = copyscore.objectAtIndex(i) as! NSNumber
                    if  num.integerValue == 100 {
                        chunk = "X"
                    }else if  num.integerValue == 0 {
                         chunk = "M"
                    }else {
                        chunk = "\(num.integerValue)"
                    }
                    
                    result += chunk
                    if i < copyscore.count-1 {
                        result += "-"
                    }
                }
                return result
            }
        }
    }
   
    
public    func getTotal() -> Int {
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
    
public    func addScore (points : Int) {
        
        let copyscore = self.scores

        if copyscore.count < NOMBREMAX {
            copyscore.addObject(NSNumber(integer: points))
        }
        
        
        let data:NSData =  NSJSONSerialization.dataWithJSONObject(copyscore,options: NSJSONWritingOptions(0), error: nil)!
        
        self.volee = NSString(data: data, encoding: NSUTF8StringEncoding)!.description
        
    }
    
 public   func deleteLast(){
        
        let copyscore = scores

        if copyscore.count != 0 {
            copyscore.removeLastObject()
        }
        
        let data:NSData =  NSJSONSerialization.dataWithJSONObject(copyscore,options: NSJSONWritingOptions(0), error: nil)!
        
        self.volee = NSString(data: data, encoding: NSUTF8StringEncoding)!.description

    }
    
  public  func getAt(fleche : Int) -> Int{
        var res:Int = -1
        let copyscore = scores
        
        if fleche < copyscore.count {
            let num:NSNumber = copyscore.objectAtIndex(fleche) as! NSNumber
            res = num.integerValue
        }
        
        return res
    }
 public   func getTaille()->Int{
         let copyscore = self.scores
        return copyscore.count
    }
    
}
