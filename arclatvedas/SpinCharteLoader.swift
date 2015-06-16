//
//  SpinCharteLoader.swift
//  arclatvedas
//
//  Created by divol on 15/06/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation
import CoreData







public class SpinCharteLoader: NSObject,NSFetchedResultsControllerDelegate {
    
    
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    //https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
    //[NSPredicate predicateWithFormat:@"title == %@ AND blockbuster.name LIKE \"Blockbuster C\"", @"Transformers 2"]

    
    //[NSPredicate predicateWithFormat:@"title == %@ AND blockbuster IN %@", @"Transformers 2", setOfBlockbusters]

    public func getAll(tablename:String)->NSFetchedResultsController{
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(tablename, inManagedObjectContext: DataManager.getContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
//        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
//        let sortDescriptors = [sortDescriptor]
//        
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
       // _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        return aFetchedResultsController
    }
    
    
    
     func loadFiles(name:String, ofType:String) ->CSV {
        let proxyBundle = NSBundle(identifier: "com.jack.CoreDataProxy")
        

        let grouppath = proxyBundle?.pathForResource(name, ofType: ofType, inDirectory:"charts")
        let csvgroupurl:NSURL = NSURL.fileURLWithPath(grouppath!,isDirectory:false)!

        
        var error: NSErrorPointer = nil
        let csv:CSV? = CSV(contentsOfURL: csvgroupurl, error: error)

//        // Rows
//        let rows = csv?.rows
//        let headers = csv?.headers
//        let alice = csv?.rows[0]
//        let rr:String? = csv?.rows[0].description
//        
//        NSLog(rr!)
//        
//        let bob = csv?.rows[1]
//        
//        // Columns
//        let columns = csv?.columns
        
        
        return csv!
    }
    
    
    func bootEaston(){
        let charte  = loadFiles("easton", ofType:"alvcharte")
        let fleche  = loadFiles("easton", ofType:"alvfleche")
        let groupe  = loadFiles("easton", ofType:"alvgroupe")
        
        
    }
    
    func bootCE(){
        let charte  = loadFiles("ce", ofType:"alvcharte")
        let fleche  = loadFiles("ce", ofType:"alvfleche")
        let groupe  = loadFiles("ce", ofType:"alvgroupe")
        
        
    }
    
    public func bootCharte(){
        bootEaston()
        bootCE()
        
    }
}




