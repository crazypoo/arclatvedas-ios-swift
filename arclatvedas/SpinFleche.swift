//
//  SpinFleche.swift
//  
//
//  Created by divol on 15/06/2015.
//
//

import Foundation
import CoreData


@objc(SpinFleche)
open class SpinFleche: NSManagedObject {

    @NSManaged open var modele: String
    @NSManaged open var name: String
    @NSManaged open var surname: String
    @NSManaged open var grain: NSNumber
    @NSManaged open var spin: String
    @NSManaged open var diametreoutside: NSNumber
    @NSManaged open var taille: NSNumber
    @NSManaged open var fabricant: String
    @NSManaged open var groupsofarrow: NSMutableOrderedSet

    
    
    override open var  description: String {
        return modele
        
        
    }
    
    override open var  debugDescription: String {
        return description
    }

}
