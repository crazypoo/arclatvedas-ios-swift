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
public class SpinFleche: NSManagedObject {

    @NSManaged public var modele: String
    @NSManaged public var name: String
    @NSManaged public var surname: String
    @NSManaged public var grain: NSNumber
    @NSManaged public var spin: String
    @NSManaged public var diametreoutside: NSNumber
    @NSManaged public var taille: NSNumber
    @NSManaged public var fabricant: String
    @NSManaged public var groupsofarrow: NSMutableOrderedSet

    
    
    override public var  description: String {
        return modele
        
        
    }
    
    override public var  debugDescription: String {
        return description
    }

}
