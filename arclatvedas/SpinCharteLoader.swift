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
    let spinCharteTable = "SpinCharte"
    let spinFlecheTable = "SpinFleche"
    let spinGroupeTable = "SpinGroupe"
    let formatter = NSNumberFormatter()

    
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

    public func getAll(tablename:String, predicate:NSPredicate?)->NSFetchedResultsController{
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(tablename, inManagedObjectContext: DataManager.getContext())
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
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
       // _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !aFetchedResultsController.performFetch(&error) {
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
    
    
    func boot(what:String){
        let charte  = loadFiles(what, ofType:"alvcharte")
        
       for (var j = 0 ; j < charte.rows.count ; j++){
            let row = charte.rows[j]
            insertSpinCharte(row)
        }
        
        let fleche  = loadFiles(what, ofType:"alvfleche")
        for (var j = 0 ; j < fleche.rows.count ; j++){
            let row = fleche.rows[j]
            insertFlecheGroupe(row)
        }
        
        let groupe  = loadFiles(what, ofType:"alvgroupe")
        
        for (var j = 0 ; j < groupe.rowsarray.count ; j++){
            let row = groupe.rowsarray[j]
            let groupe:String = row["group"]!.first!
            let fleches:[String] = row["modele"]!
             for (var i = 0 ; i < fleches.count ; i++){
                
                let modele = fleches[i] as String
                if (modele != "" ){
                    associateGroupeAndFleche(groupe, modelefleche:modele)
                }
            }
            
        }

        let context = DataManager.getContext()
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }


    }
    public func bootEaston(){
        
        boot("easton")
    }
    public func bootCE(){
        
        boot("ce")
    }
    
    
    func str2nsnumber(str:String)->NSNumber{
        
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
        if let number = formatter.numberFromString(str) {
            return number
        }
        return  NSNumber(float:0.0)
    }
    
    public func insertSpinCharte(entry:Dictionary<String, String>) {
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName(spinCharteTable, inManagedObjectContext: context)
        
        let spinCharte = SpinCharte(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
       // length;low;hight;group;groupname
        spinCharte.length =   str2nsnumber(entry["length"]!)
        spinCharte.low = str2nsnumber(entry["low"]!)
        spinCharte.hight = str2nsnumber(entry["hight"]!)
        
        let group = insertSpinGroupe(entry["groupname"]!)
        spinCharte.group=[]
        spinCharte.group.addObject(group)

        group.chart.addObject(spinCharte)

        // spinCharte.group
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
    }

     func insertSpinGroupe(groupename: String)-> SpinGroupe{
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName(spinGroupeTable, inManagedObjectContext: context)
        
        let spinGroupe = SpinGroupe(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
        // length;low;hight;group;groupname

//        @NSManaged var name: String
//        @NSManaged var chart: NSMutableOrderedSet
//        @NSManaged var arrow: NSMutableOrderedSet

        spinGroupe.name  = groupename
        spinGroupe.chart=[]
        spinGroupe.arrow=[]
        return spinGroupe;
    }
    
    
    func insertFlecheGroupe(entry:Dictionary<String, String>){
        
//        @NSManaged var modele: String
//        @NSManaged var name: String
//        @NSManaged var surname: String
//        @NSManaged var grain: NSNumber
//        @NSManaged var spin: NSNumber
//        @NSManaged var diametreoutside: NSNumber
//        @NSManaged var taille: NSNumber
//        @NSManaged var fabricant: String
//        @NSManaged var groupe: NSMutableOrderedSet
        // id;modele;name;surname;grain;spin;diametreoutside;taille;fabricant

        
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName(spinFlecheTable, inManagedObjectContext: context)
        
        let spinFleche = SpinFleche(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())

        spinFleche.modele = entry["modele"]!
        spinFleche.name = entry["name"]!
        spinFleche.surname = entry["surname"]!
        spinFleche.grain = str2nsnumber(entry["grain"]!)
        spinFleche.spin = str2nsnumber(entry["spin"]!)
        spinFleche.diametreoutside = str2nsnumber(entry["diametreoutside"]!)
        spinFleche.taille = str2nsnumber(entry["taille"]!)
        spinFleche.fabricant = entry["fabricant"]!
        spinFleche.groupe=[]
        // spinFleche.groupe
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

    }
    
    func getGroupe(groupename:String)-> SpinGroupe{
       
        let  predicate:NSPredicate =  NSPredicate(format: "name == %@",groupename)

        let result:NSFetchedResultsController = getAll(spinGroupeTable, predicate:predicate)
        var indexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)

        return result.objectAtIndexPath( indexPath) as! SpinGroupe
        
    }
    
    func getFleche(modelename:String)-> SpinFleche{
        
        let  predicate:NSPredicate =  NSPredicate(format: "modele == %@",modelename)
        
        let result:NSFetchedResultsController = getAll(spinFlecheTable, predicate:predicate)
        var indexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        return result.objectAtIndexPath( indexPath) as! SpinFleche
        
    }

    
    
    func associateGroupeAndFleche(groupename:String, modelefleche:String){
        let group = getGroupe(groupename)
        let fleche = getFleche(modelefleche)
        
        group.arrow.addObject(fleche)
        fleche.groupe.addObject(group)
        
    }
    
    
    

    func getGroupes(length:NSNumber,weight:NSNumber)-> NSFetchedResultsController{
        
        let  predicate:NSPredicate =  NSPredicate(format: "length == %@ and low <= %@ and hight >=%@",length,weight,weight)
        
        let result:NSFetchedResultsController = getAll(spinCharteTable, predicate:predicate)

        
        return result
        
    }

    
    
    public func testrequests(){
        
        
       let result =  getGroupes(29,weight:21)
        NSLog(result.description);
        
        
        for (var i = 0 ; i<result.fetchedObjects!.count ; i++){
            let indexPath:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let toto = result.objectAtIndexPath( indexPath) as! SpinCharte
           let spinGroupe = toto.group.objectAtIndex(0) as! SpinGroupe
            NSLog(spinGroupe.name);
            
            NSLog( "count = \(spinGroupe.arrow.count)")
            for (var j = 0 ; j < spinGroupe.arrow.count ; j++){
                
                let arrow = spinGroupe.arrow.objectAtIndex(j) as! SpinFleche;
                NSLog(arrow.modele);
                
            }
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    public  func bootCharte(){
        
        let result:NSFetchedResultsController? = getAll("SpinFleche", predicate:nil)
        
        if (result!.fetchedObjects!.count == 0) {
            bootEaston()
            bootCE()
        }
        
        testrequests()
    }

}




