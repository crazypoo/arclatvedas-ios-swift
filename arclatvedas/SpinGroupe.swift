//
//  SpinGroupe.swift
//  
//
//  Created by divol on 15/06/2015.
//
//

import Foundation
import CoreData


@objc(SpinGroupe)
public class SpinGroupe: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var chart: NSMutableOrderedSet
    @NSManaged public var arrowsofgroup: NSMutableOrderedSet

    
     override public var description: String {
            return "\(name)"
    
    
    }
    
    override public var debugDescription: String {
        return description
    }
    
    
}
