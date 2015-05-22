//
//  DataManager.swift
//  arclatvedas
//
//  Created by divol on 22/05/2015.
// from http://makeandbuild.com/blog/post/watchkit-with-shared-core-data
//


import CoreData

public class DataManager: NSObject {
    
    public class func getContext() -> NSManagedObjectContext {
        return CoreDataProxy.sharedInstance.managedObjectContext!
    }
    
    public class func deleteManagedObject(object:NSManagedObject) {
        getContext().deleteObject(object)
        saveManagedContext()
    }
    
    public class func saveManagedContext() {
        var error : NSError? = nil
        if !getContext().save(&error) {
            NSLog("Unresolved error saving context \(error), \(error!.userInfo)")
            abort()
        }
    }
    
}
