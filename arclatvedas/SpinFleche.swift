//
//  SpinFleche.swift
//  
//
//  Created by divol on 15/06/2015.
//
//

import Foundation
import CoreData

class SpinFleche: NSManagedObject {

    @NSManaged var modele: String
    @NSManaged var name: String
    @NSManaged var surname: String
    @NSManaged var grain: NSNumber
    @NSManaged var spin: NSNumber
    @NSManaged var diametreoutside: NSNumber
    @NSManaged var taille: NSNumber
    @NSManaged var fabricant: String
    @NSManaged var groupe: NSMutableOrderedSet

}
