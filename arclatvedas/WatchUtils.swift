//
//  WatchUtils.swift
//  arclatvedas
//
//  Created by divol on 21/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation
import CoreData

public class WatchUtils : NSObject,NSFetchedResultsControllerDelegate{

//var managedObjectContext: NSManagedObjectContext? = nil

// MARK: - Fetched results controller

var fetchedResultsController: NSFetchedResultsController {
    if _fetchedResultsController != nil {
        return _fetchedResultsController!
    }
    
    let fetchRequest = NSFetchRequest()
    // Edit the entity name as appropriate.
    let entity = NSEntityDescription.entityForName(self.tablename, inManagedObjectContext: DataManager.getContext())
    fetchRequest.entity = entity
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
   // let sortDescriptors = [sortDescriptor]
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    var error: NSError? = nil
    do {
        try _fetchedResultsController!.performFetch()
    } catch let error1 as NSError {
        error = error1
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        print("Unresolved error \(error), \(error!.userInfo)")
        abort()
    }
    
    return _fetchedResultsController!
}
var _fetchedResultsController: NSFetchedResultsController? = nil

    
    
    var tablename:String = "[Unnamed]" {
        didSet {
            // Update the view.
        }
    }

    
 public  func getLastTir( ) ->AnyObject!{
        
        
         NSFetchedResultsController.deleteCacheWithName("Master")
    _fetchedResultsController=nil
       var object:Tir?
        tablename = "Tir";
    if let ff:NSFetchedResultsController = self.fetchedResultsController{
        let cocos: [Tir] = ff.fetchedObjects as! [Tir]
        
        if  cocos.count > 0 {
            
             object = cocos[0]
        }
//        else{
//            insertNewTir()
//            return getLastTir( )
//            
//        }
    }
        return object
    

    }
    
    
    public func createEmptyVolee(tir:Tir){
        
        
        
        
        let entityDescription = NSEntityDescription.entityForName("Volee", inManagedObjectContext: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
        
        volee.setValue("[]", forKey: "volee")
        volee.setValue(tir, forKey: "relationship")
        volee.setValue(0 ,forKey: "rang")
        
        
        
        tir.volees.addObject(volee)
        
    }
    
    
    
    
    func insertNewTirObject(newManagedObject: Tir) {
        
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue("Au club", forKey: "location")
        newManagedObject.setValue("70", forKey: "distance")
        newManagedObject.setValue("", forKey: "comment")
        
        // test
        let entityDescription = NSEntityDescription.entityForName("Volee", inManagedObjectContext: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
        
        volee.volee = "[]"
        volee.rang = 1
        
        volee.relationship = newManagedObject
        
        
        
        newManagedObject.volees.addObject(volee)
        
        
    }

    
    
    
   public func insertNewTir() {
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName("Tir", inManagedObjectContext: context)
        
        let tir = Tir(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())

         insertNewTirObject(tir)
        
        
        
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        // Save the context.
        var error: NSError? = nil
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
    }

    
    

}









