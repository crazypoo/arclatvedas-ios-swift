//
//  SpinCharte.swift
//  
//
//  Created by divol on 15/06/2015.
//
//

import Foundation
import CoreData

@objc(SpinCharte)

class SpinCharte: NSManagedObject {

    @NSManaged var length: NSNumber
    @NSManaged var low: NSNumber
    @NSManaged var hight: NSNumber
    @NSManaged var group: NSMutableOrderedSet

}
