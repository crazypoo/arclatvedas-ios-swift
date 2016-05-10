//
//  Distance.swift
//  
//
//  Created by divol on 29/04/2015.
//
//

import Foundation
import CoreData

//http://stackoverflow.com/questions/26613971/swift-coredata-warning-unable-to-load-class-named

@objc(Distance)

public class Distance: NSManagedObject {

    @NSManaged public var comment: String
    @NSManaged public var name: String
    @NSManaged public var timeStamp: NSDate
    @NSManaged public var unit: String
    @NSManaged public var relationship: NSMutableSet
    
    
    
  public  func allHaussesDescription ()->String {
        
        var result = ""

        var nsarr = self.relationship.allObjects as! [Hausse]
        
       nsarr.sortInPlace({ (s1: Hausse, s2: Hausse) -> Bool in
            return Int(s1.name) < Int(s2.name)
        })
        
        
        for  hausse:Hausse in nsarr{

            result += "\(hausse.name)=\(hausse.hausse) "

        }
        return result
    }
  public  func getAllHaussesSorted () -> NSArray {
        
        var nsarray:[Hausse] = self.relationship.allObjects as! [Hausse]
        
        nsarray.sortInPlace({ (s1: Hausse, s2: Hausse) -> Bool in
            return Int(s1.name) < Int(s2.name)
        })
        return NSArray(array: nsarray)
    }
}
