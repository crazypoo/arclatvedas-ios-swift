//
//  Event.swift
//  arclatvedas
//
//  Created by divol on 24/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var timeStamp: NSDate
    @NSManaged var name: String
    @NSManaged var url: String

}
