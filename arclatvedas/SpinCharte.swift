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

open class SpinCharte: NSManagedObject {

    @NSManaged open var length: NSNumber
    @NSManaged open var low: NSNumber
    @NSManaged open var hight: NSNumber
    @NSManaged open var group: NSMutableOrderedSet

}
