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
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: "MasterCharte")
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

       DataManager.saveManagedContext()


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
        }else{
            let newString = str.stringByReplacingOccurrencesOfString(",", withString: ".")
            if let number = formatter.numberFromString(newString) {
                return number
            }
        }
        return  NSNumber(float:0.0)
    }
    
    
    
    public func insertSpinCharte(entry:Dictionary<String, String>) {
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName(spinCharteTable, inManagedObjectContext: context)
        
        let spinCharte = SpinCharte(entity: entityDescription!, insertIntoManagedObjectContext: context)

        
        spinCharte.setValue(str2nsnumber(entry["length"]!), forKey: "length")
        spinCharte.setValue(str2nsnumber(entry["low"]!), forKey: "low")
        spinCharte.setValue(str2nsnumber(entry["hight"]!), forKey: "hight")
        
        let group = insertSpinGroupe(entry["groupname"]!)

        group.chart.addObject(spinCharte)
        

        spinCharte.group.addObject(group)

        
        
    }

     func insertSpinGroupe(groupename: String)-> SpinGroupe{
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName(spinGroupeTable, inManagedObjectContext: context)
        
        let spinGroupe = SpinGroupe(entity: entityDescription!, insertIntoManagedObjectContext: context)

        spinGroupe.setValue(groupename, forKey: "name")

        return spinGroupe;
    }
    
    
    func insertFlecheGroupe(entry:Dictionary<String, String>){
        

        
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entityForName(spinFlecheTable, inManagedObjectContext: context)
        
        let spinFleche = SpinFleche(entity: entityDescription!, insertIntoManagedObjectContext: context)

        
        spinFleche.setValue(entry["modele"]!, forKey: "modele")
        spinFleche.setValue(entry["name"]!, forKey: "name")
        spinFleche.setValue(entry["surname"]!, forKey: "surname")
        spinFleche.setValue(str2nsnumber(entry["grain"]!), forKey: "grain")
        spinFleche.setValue(entry["spin"]!, forKey: "spin")
        spinFleche.setValue(str2nsnumber(entry["diametreoutside"]!), forKey: "diametreoutside")
        spinFleche.setValue(str2nsnumber(entry["taille"]!), forKey: "taille")
        spinFleche.setValue(entry["fabricant"]!, forKey: "fabricant")

        
    }
    
    func getGroupe(groupename:String)-> SpinGroupe{
       
        let  predicate:NSPredicate =  NSPredicate(format: "name == %@",groupename)

        let result:NSFetchedResultsController = getAll(spinGroupeTable, predicate:predicate)
        
          //NSLog( "getGroupe resultcount = \(result.fetchedObjects!.count)")

        return result.fetchedObjects?.first as! SpinGroupe
        
    }
    
    func getFleche(modelename:String)-> SpinFleche{
        
        let  predicate:NSPredicate =  NSPredicate(format: "modele == %@",modelename)
        
        let result:NSFetchedResultsController = getAll(spinFlecheTable, predicate:predicate)
        //NSLog( "getFleche resultcount = \(result.fetchedObjects!.count)")

        
        return result.fetchedObjects?.first as! SpinFleche
        
    }

    
    
    func getGroupeR(groupename:String)-> NSFetchedResultsController{
        
        let  predicate:NSPredicate =  NSPredicate(format: "name == %@",groupename)
        
        let result:NSFetchedResultsController = getAll(spinGroupeTable, predicate:predicate)
        
        //  NSLog( "getGroupe resultcount = \(result.fetchedObjects!.count)")
        
        return result
        
    }
    
    func getFlecheR(modelename:String)-> NSFetchedResultsController{
        
        let  predicate:NSPredicate =  NSPredicate(format: "modele == %@",modelename)
        
        let result:NSFetchedResultsController = getAll(spinFlecheTable, predicate:predicate)
        //  NSLog( "getFleche resultcount = \(result.fetchedObjects!.count)")
        
        
        return result
        
    }

    
    
    
    
    
    func associateGroupeAndFleche(groupename:String, modelefleche:String){
        
        var fleche:SpinFleche = getFleche(modelefleche)

        var groups = getGroupeR(groupename)
        for group in groups.fetchedObjects as! [SpinGroupe] {
            group.arrowsofgroup.addObject(fleche)
            fleche.groupsofarrow.addObject(group)


        }


        
        
        
    }
    
    
    

    public class func getGroupes(length:NSNumber,weight:NSNumber)-> NSFetchedResultsController{
        var  predicate:NSPredicate?=nil

        if (length == 0 ) &&  (weight == 0 ){
            

        }else{
            if (weight == 0 ){
                  predicate =  NSPredicate(format: "length == %@",length)

            }else{
                if (length == 0 ){
                      predicate =  NSPredicate(format: "low <= %@ and hight >=%@",length,weight,weight)

                }else{
                      predicate =  NSPredicate(format: "length == %@ and low <= %@ and hight >=%@",length,weight,weight)

                }

            }
        }
        
        let result:NSFetchedResultsController = DataManager.getAll("SpinCharte", predicate:predicate, delegate:nil)

        
        return result
        
    }

     func getGroupesO(length:NSNumber,weight:NSNumber)-> NSFetchedResultsController{
        
        let  predicate:NSPredicate =  NSPredicate(format: "length == %@ and low <= %@ and hight >=%@",length,weight,weight)
        
        let result:NSFetchedResultsController = getAll(spinCharteTable, predicate:predicate)
        
        
        return result
        
    }

    
    public func testrequests(){
        
        
       var result =   getGroupesO(29,weight:21)
        
        
        for (var i = 0 ; i<result.fetchedObjects!.count ; i++){
            let indexPath:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let toto = result.objectAtIndexPath( indexPath) as! SpinCharte
           let spinGroupe = toto.group.objectAtIndex(0) as! SpinGroupe
            NSLog(spinGroupe.name);
            
            NSLog( "count = \(spinGroupe.arrowsofgroup.count)")
            for (var j = 0 ; j < spinGroupe.arrowsofgroup.count ; j++){
                
                let arrow = spinGroupe.arrowsofgroup.objectAtIndex(j) as! SpinFleche;
                NSLog(arrow.modele);
                
            }
            
            
        }
        
    }
    
    
    public  func bootCharte(){
        
        let resultSpinFleche:NSFetchedResultsController? = getAll("SpinFleche", predicate:nil)
         NSLog( "count = \(resultSpinFleche!.fetchedObjects!.count)")
        
        let resultSpinCharte:NSFetchedResultsController? = getAll("SpinCharte", predicate:nil)
        NSLog( "count = \(resultSpinCharte!.fetchedObjects!.count)")

        let resultspinGroupeTable:NSFetchedResultsController? = getAll("SpinGroupe", predicate:nil)
        NSLog( "count = \(resultspinGroupeTable!.fetchedObjects!.count)")

        if (resultSpinFleche!.fetchedObjects!.count == 0) {
            bootEaston()
            bootCE()

        }
        
       // testrequests()
    }

}




