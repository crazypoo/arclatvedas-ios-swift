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

class Hausse: NSManagedObject {

    @NSManaged var hausse: String
    @NSManaged var name: String
    @NSManaged var relationship: NSManagedObject

}
