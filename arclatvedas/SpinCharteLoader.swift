//
//  SpinCharteLoader.swift
//  arclatvedas
//
//  Created by divol on 15/06/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation
import CoreData







open class SpinCharteLoader: NSObject,NSFetchedResultsControllerDelegate {
    let spinCharteTable = "SpinCharte"
    let spinFlecheTable = "SpinFleche"
    let spinGroupeTable = "SpinGroupe"
    let formatter = NumberFormatter()
    
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    //https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
    //[NSPredicate predicateWithFormat:@"title == %@ AND blockbuster.name LIKE \"Blockbuster C\"", @"Transformers 2"]
    
    
    //[NSPredicate predicateWithFormat:@"title == %@ AND blockbuster IN %@", @"Transformers 2", setOfBlockbusters]
    
    open func getAll(_ tablename:String, predicate:NSPredicate?)->NSFetchedResultsController<NSFetchRequestResult>{
        
        
        
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: tablename, in: DataManager.getContext())
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
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil) //"MasterCharte"
        aFetchedResultsController.delegate = self
        // _fetchedResultsController = aFetchedResultsController
        
        // var error: NSError? = nil
        do {
            try aFetchedResultsController.performFetch()
        } catch  _ as NSError {
            // error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        return aFetchedResultsController
    }
    
    
    
    func loadFiles(_ name:String, ofType:String) ->CSV {
        let proxyBundle = Bundle(identifier: "com.jack.CoreDataProxy")
        
        
        let grouppath = proxyBundle?.path(forResource: name, ofType: ofType, inDirectory:"charts")
        let csvgroupurl:URL = URL(fileURLWithPath: grouppath!,isDirectory:false)
        
        
        let error: NSErrorPointer? = nil
        let csv:CSV?
        do {
            csv = try CSV(contentsOfURL: csvgroupurl)
        } catch let error1 as NSError {
            error??.pointee = error1
            csv = nil
        }
        
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
    
    
    func boot(_ what:String){
        let charte  = loadFiles(what, ofType:"alvcharte")
        
        for j in 0  ..< charte.rows.count {
            let row = charte.rows[j]
            insertSpinCharte(row)
        }
        let fleche  = loadFiles(what, ofType:"alvfleche")
        for j in 0  ..< fleche.rows.count {
            let row = fleche.rows[j]
            insertFlecheGroupe(row)
        }
        let groupe  = loadFiles(what, ofType:"alvgroupe")
        
        for j in 0  ..< groupe.rowsarray.count  {
            let row = groupe.rowsarray[j]
            let groupe:String = row["group"]!.first!
            let fleches:[String] = row["modele"]!
            for i in 0  ..< fleches.count{
                
                let modele = fleches[i] as String
                if (modele != "" ){
                    associateGroupeAndFleche(groupe, modelefleche:modele)
                }
            }
            
        }
        
        DataManager.saveManagedContext()
        
        
    }
    open func bootEaston(){
        
        boot("easton")
    }
    open func bootCE(){
        
        boot("ce")
    }
    
    
    func str2nsnumber(_ str:String)->NSNumber{
        
        formatter.numberStyle = NumberFormatter.Style.decimal;
        if let number = formatter.number(from: str) {
            return number
        }else{
            let newString = str.replacingOccurrences(of: ",", with: ".")
            if let number = formatter.number(from: newString) {
                return number
            }
        }
        return  NSNumber(value: 0.0 as Float)
    }
    
    
    
    open func insertSpinCharte(_ entry:Dictionary<String, String>) {
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: spinCharteTable, in: context)
        
        let spinCharte = SpinCharte(entity: entityDescription!, insertInto: context)
        
        
        spinCharte.setValue(str2nsnumber(entry["length"]!), forKey: "length")
        spinCharte.setValue(str2nsnumber(entry["low"]!), forKey: "low")
        spinCharte.setValue(str2nsnumber(entry["hight"]!), forKey: "hight")
        
        let group = insertSpinGroupe(entry["groupname"]!)
        
        group.chart.add(spinCharte)
        
        
        spinCharte.group.add(group)
        
        
        
    }
    
    func insertSpinGroupe(_ groupename: String)-> SpinGroupe{
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: spinGroupeTable, in: context)
        
        let spinGroupe = SpinGroupe(entity: entityDescription!, insertInto: context)
        
        spinGroupe.setValue(groupename, forKey: "name")
        
        return spinGroupe;
    }
    
    
    func insertFlecheGroupe(_ entry:Dictionary<String, String>){
        
        
        
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: spinFlecheTable, in: context)
        
        let spinFleche = SpinFleche(entity: entityDescription!, insertInto: context)
        
        
        spinFleche.setValue(entry["modele"]!, forKey: "modele")
        spinFleche.setValue(entry["name"]!, forKey: "name")
        spinFleche.setValue(entry["surname"]!, forKey: "surname")
        spinFleche.setValue(str2nsnumber(entry["grain"]!), forKey: "grain")
        spinFleche.setValue(entry["spin"]!, forKey: "spin")
        spinFleche.setValue(str2nsnumber(entry["diametreoutside"]!), forKey: "diametreoutside")
        spinFleche.setValue(str2nsnumber(entry["taille"]!), forKey: "taille")
        spinFleche.setValue(entry["fabricant"]!, forKey: "fabricant")
        
        
    }
    
    func getGroupe(_ groupename:String)-> SpinGroupe{
        
        let  predicate:NSPredicate =  NSPredicate(format: "name == %@",groupename)
        
        let result:NSFetchedResultsController = getAll(spinGroupeTable, predicate:predicate)
        
        //NSLog( "getGroupe resultcount = \(result.fetchedObjects!.count)")
        
        return result.fetchedObjects?.first as! SpinGroupe
        
    }
    
    func getFleche(_ modelename:String)-> SpinFleche{
        
        let  predicate:NSPredicate =  NSPredicate(format: "modele == %@",modelename)
        
        let result:NSFetchedResultsController = getAll(spinFlecheTable, predicate:predicate)
        //NSLog( "getFleche resultcount = \(result.fetchedObjects!.count)")
        
        
        return result.fetchedObjects?.first as! SpinFleche
        
    }
    
    
    
    func getGroupeR(_ groupename:String)-> NSFetchedResultsController<NSFetchRequestResult>{
        
        let  predicate:NSPredicate =  NSPredicate(format: "name == %@",groupename)
        
        let result:NSFetchedResultsController = getAll(spinGroupeTable, predicate:predicate)
        
        //  NSLog( "getGroupe resultcount = \(result.fetchedObjects!.count)")
        
        return result
        
    }
    
    func getFlecheR(_ modelename:String)-> NSFetchedResultsController<NSFetchRequestResult>{
        
        let  predicate:NSPredicate =  NSPredicate(format: "modele == %@",modelename)
        
        let result:NSFetchedResultsController = getAll(spinFlecheTable, predicate:predicate)
        //  NSLog( "getFleche resultcount = \(result.fetchedObjects!.count)")
        
        
        return result
        
    }
    
    
    
    
    
    
    func associateGroupeAndFleche(_ groupename:String, modelefleche:String){
        
        let fleche:SpinFleche = getFleche(modelefleche)
        
        let groups = getGroupeR(groupename)
        for group in groups.fetchedObjects as! [SpinGroupe] {
            group.arrowsofgroup.add(fleche)
            fleche.groupsofarrow.add(group)
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    open class func getGroupes(_ length:NSNumber,_ weight:NSNumber)-> NSFetchedResultsController<NSFetchRequestResult>{
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
    
    func getGroupesO(_ length:NSNumber,weight:NSNumber)-> NSFetchedResultsController<NSFetchRequestResult>{
        
        let  predicate:NSPredicate =  NSPredicate(format: "length == %@ and low <= %@ and hight >=%@",length,weight,weight)
        
        let result:NSFetchedResultsController = getAll(spinCharteTable, predicate:predicate)
        
        
        return result
        
    }
    
    
    open func testrequests(){
        
        
        let result =   getGroupesO(29,weight:21)
        
        
        for i in 0 ..< result.fetchedObjects!.count{
            let indexPath:IndexPath = IndexPath(index: i)
            
            let toto = result.object( at: indexPath) as! SpinCharte
            let spinGroupe = toto.group.object(at: 0) as! SpinGroupe
            NSLog(spinGroupe.name);
            
            NSLog( "count = \(spinGroupe.arrowsofgroup.count)")
            for j in 0 ..< spinGroupe.arrowsofgroup.count {
                
                let arrow = spinGroupe.arrowsofgroup.object(at: j) as! SpinFleche;
                NSLog(arrow.modele);
                
            }
            
            
        }
        
    }
    
    
    open  func bootCharte(){
        
        let resultSpinFleche:NSFetchedResultsController? = getAll("SpinFleche", predicate:nil)
        //  NSLog( "count = \(resultSpinFleche!.fetchedObjects!.count)")
        
        let resultSpinCharte:NSFetchedResultsController? = getAll("SpinCharte", predicate:nil)
        //  NSLog( "count = \(resultSpinCharte!.fetchedObjects!.count)")
        
        let resultspinGroupeTable:NSFetchedResultsController? = getAll("SpinGroupe", predicate:nil)
        // NSLog( "count = \(resultspinGroupeTable!.fetchedObjects!.count)")
        
        if (resultSpinFleche!.fetchedObjects!.count == 0) {
            bootEaston()
            bootCE()
            
        }
        
        // testrequests()
    }
    
}




