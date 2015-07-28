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
   @NSManaged var impactes: NSData
   @NSManaged var zones: NSData
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

    public var impacteArray:NSMutableArray{
        get {
            if self.impactes.length == 0 {
                let copyimpacteArray = NSMutableArray(capacity:0)
                self.impactes = NSKeyedArchiver.archivedDataWithRootObject(copyimpacteArray)
            }
            //NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:myMutableArray];
            let k:NSMutableArray =  (NSKeyedUnarchiver.unarchiveObjectWithData(self.impactes) as? NSMutableArray)!
            

            return k
            
            
        }

    }
    
    public var zoneArray:NSMutableArray{
        get {
            if self.zones.length == 0 {
                let copyzoneArray = NSMutableArray(capacity:0)
                self.zones = NSKeyedArchiver.archivedDataWithRootObject(copyzoneArray)
            }
            let k:NSMutableArray =  (NSKeyedUnarchiver.unarchiveObjectWithData(self.zones) as? NSMutableArray)!
            
            
            return k
            
            
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
    
    public func addScore (points : Int, impact:CGPoint, zone:CGPoint)->Bool {
        
        let copyscore = self.scores
        var done=false
        
        if copyscore.count < NOMBREMAX {
            copyscore.addObject(NSNumber(integer: points))
        }
        
        
        let data:NSData =  NSJSONSerialization.dataWithJSONObject(copyscore,options: NSJSONWritingOptions(0), error: nil)!
        
        self.volee = NSString(data: data, encoding: NSUTF8StringEncoding)!.description
        
        

      //  NSString *pointToSavae = NSStringFromCGPoint(point); // Will store string {20,20}

        
        let copyimpacteArray = self.impacteArray
        if copyscore.count < NOMBREMAX {
            copyimpacteArray.addObject(NSValue(CGPoint:impact))
            done=true
        }
        
        self.impactes = NSKeyedArchiver.archivedDataWithRootObject(copyimpacteArray)
        
        
        let copyzoneArray = self.zoneArray
        if copyscore.count < NOMBREMAX {
            copyzoneArray.addObject(NSValue(CGPoint:zone))
        }
        
        self.zones = NSKeyedArchiver.archivedDataWithRootObject(copyzoneArray)

        
        
        return done
    }
    
 public   func deleteLast()->Bool{
        var done=false
        let copyscore = scores

        if copyscore.count != 0 {
            copyscore.removeLastObject()
        }
        
        let data:NSData =  NSJSONSerialization.dataWithJSONObject(copyscore,options: NSJSONWritingOptions(0), error: nil)!
        
        self.volee = NSString(data: data, encoding: NSUTF8StringEncoding)!.description
    
        let copyimpacteArray = self.impacteArray
        if copyimpacteArray.count != 0 {
            copyimpacteArray.removeLastObject()
            done=true
        }
    
        self.impactes = NSKeyedArchiver.archivedDataWithRootObject(copyimpacteArray)
    
        let copyzoneArray = self.zoneArray
        if copyzoneArray.count != 0 {
            copyzoneArray.removeLastObject()
        }
    
        self.zones = NSKeyedArchiver.archivedDataWithRootObject(copyzoneArray)

    
    
        return done
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
    
    public func getImpactAt(fleche:Int) ->CGPoint{
        
        let copyimpacteArray = self.impacteArray
        var point = CGPointMake(0,0)
        if fleche < copyimpacteArray.count {
          point = copyimpacteArray.objectAtIndex(fleche).CGPointValue()
        }
        
        return point
    }
    
    public func getZoneAt(fleche:Int) ->CGPoint{
        
        let copyzoneArray = self.zoneArray
        var point = CGPointMake(0,0)
        if fleche < copyzoneArray.count {
            point = copyzoneArray.objectAtIndex(fleche).CGPointValue()
        }
        
        return point
    }

    
    
 public   func getTaille()->Int{
         let copyscore = self.scores
        return copyscore.count
    }
    
}
