//
//  Tir.swift
//  
//
//  Created by divol on 29/04/2015.
//
//

import Foundation
import CoreData

@objc(Tir)
class Tir: NSManagedObject {

    @NSManaged var comment: String
    @NSManaged var distance: String
    @NSManaged var location: String
    @NSManaged var timeStamp: NSDate
    @NSManaged var volees: NSMutableOrderedSet

    
    
    
    func getTotal() -> Int {
        
        var totale = 0
        
        
        var nsarr = self.volees.array as! [Volee]
        
        if self.volees.count > 0 {
            for  vol:Volee in nsarr{
            
                totale += vol.getTotal()
            
            }

        }
        return totale
    }
    
//    func getJson()->String{
//        
//        
//        let dateFormat:NSDateFormatter = NSDateFormatter()
//        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormat.dateFormat="dd/MM/yy"
//        let dateString:String = dateFormat.stringFromDate(timeStamp)
//
//        
//        
//        var dico:Dictionary<String,AnyObject> = ["location":location,"distance":distance,
//            "timeStamp": dateString, "volees":volees]
//        
//        let data:NSData =  NSJSONSerialization.dataWithJSONObject(dico,options: NSJSONWritingOptions(0), error: nil)!
//        
//        return NSString(data: data, encoding: NSUTF8StringEncoding)!.description
//
//        
//    }
}
