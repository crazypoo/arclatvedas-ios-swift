//
//  DataManager.swift
//  arclatvedas
//
//  Created by divol on 22/05/2015.
// from http://makeandbuild.com/blog/post/watchkit-with-shared-core-data
//


import CoreData

open class DataManager: NSObject {
    
    open class func getContext() -> NSManagedObjectContext {
        return CoreDataProxy.sharedInstance.managedObjectContext!
    }
    
    open class func deleteManagedObject(_ object:NSManagedObject) {
        getContext().delete(object)
        saveManagedContext()
    }
    
    
    open class func getAll(_ tablename:String, predicate:NSPredicate?, delegate:NSFetchedResultsControllerDelegate?)->NSFetchedResultsController<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tablename)
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: tablename, in:  getContext())
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        //        // Edit the sort key as appropriate.
        //        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        //        let sortDescriptors = [sortDescriptor]
        //
        fetchRequest.sortDescriptors = []
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getContext(), sectionNameKeyPath: nil, cacheName: nil) //"Master"
         aFetchedResultsController.delegate = delegate
        // _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        do {
            try aFetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        return aFetchedResultsController
    }

    
    
    
    open class func emptyManagedTable(_ tableName:String){
        
       let all = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        var error : NSError? = nil
        let entity = NSEntityDescription.entity(forEntityName: tableName, in:  getContext())
        all.entity = entity
        all.includesPropertyValues = true //only fetch the managedObjectID
        
        
        
        do {
            let data =  try getContext().fetch(all)

            //error handling goes here
            for result in data {
                deleteManagedObject(result as! NSManagedObject)
            }
        } catch let error1 as NSError {
            error = error1
            NSLog("Unresolved error saving context \(error), \(error!.userInfo)")
        }
        saveManagedContext()
    }
    open class func saveManagedContext() {
        var error : NSError? = nil
        do {
            try getContext().save()
        } catch let error1 as NSError {
            error = error1
            NSLog("Unresolved error saving context \(error), \(error!.userInfo)")
            abort()
        }
    }
    
}
