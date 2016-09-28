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

open class Hausse: NSManagedObject {

    @NSManaged open var hausse: String
    @NSManaged open var name: String
    @NSManaged open var relationship: NSManagedObject

}
