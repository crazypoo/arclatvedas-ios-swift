//
//  WatchUtils.swift
//  arclatvedas
//
//  Created by divol on 21/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation
import CoreData
import CoreDataProxy

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
    let sortDescriptors = [sortDescriptor]
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    var error: NSError? = nil
    if !_fetchedResultsController!.performFetch(&error) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //println("Unresolved error \(error), \(error.userInfo)")
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
        
        
        
        var indexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        _fetchedResultsController=nil

        tablename = "Tir";
        let object:Tir = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tir
       
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

}









