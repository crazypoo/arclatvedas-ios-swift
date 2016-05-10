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

public class SpinCharte: NSManagedObject {

    @NSManaged public var length: NSNumber
    @NSManaged public var low: NSNumber
    @NSManaged public var hight: NSNumber
    @NSManaged public var group: NSMutableOrderedSet

}
