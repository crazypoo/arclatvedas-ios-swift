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
class SpinGroupe: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var chart: NSMutableOrderedSet
    @NSManaged var arrow: NSMutableOrderedSet

}
