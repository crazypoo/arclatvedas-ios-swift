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
open class SpinGroupe: NSManagedObject {

    @NSManaged open var name: String
    @NSManaged open var chart: NSMutableOrderedSet
    @NSManaged open var arrowsofgroup: NSMutableOrderedSet

    
     override open var description: String {
            return "\(name)"
    
    
    }
    
    override open var debugDescription: String {
        return description
    }
    
    
}
