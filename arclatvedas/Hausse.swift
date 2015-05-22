//
//  Hausse.swift
//  
//
//  Created by divol on 29/04/2015.
//
//

import Foundation
import CoreData

//http://stackoverflow.com/questions/26613971/swift-coredata-warning-unable-to-load-class-named
@objc(Hausse)

public class Hausse: NSManagedObject {

    @NSManaged public var hausse: String
    @NSManaged public var name: String
    @NSManaged public var relationship: NSManagedObject

}
