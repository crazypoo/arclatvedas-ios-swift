//
//  ListeViewController.swift
//  arclatvedas
//
//  Created by divol on 27/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation


import UIKit
import CoreData
import CoreDataProxy

class ListeViewController : UITableViewController, NSFetchedResultsControllerDelegate{
   // var managedObjectContext: NSManagedObjectContext? = nil
    
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
            self.configureView()
        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        self.fetchedResultsController
        switch tablename{
            
        case "Materiel":
            self.navigationItem.title =  NSLocalizedString("Matériel", comment:"title")
            
        case "Distance":
           self.navigationItem.title = NSLocalizedString("Distances", comment:"title")
            
            
        case "Tir":
            self.navigationItem.title = NSLocalizedString("Scores", comment:"title")
        
        case "Fleche":
            self.navigationItem.title = NSLocalizedString("Flèches", comment:"title")
            
        default: break
            
            
        }


    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
                //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
                let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
                self.navigationItem.rightBarButtonItem = addButton
    }

 override   func viewWillAppear(animated: Bool){
          self.tableView.reloadData()
    }
    func insertNewMatosObject(newManagedObject: AnyObject) {
        
        let locastr=NSLocalizedString("Matériel", comment:"data")
        
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "name")
        newManagedObject.setValue("S/N 00000000000", forKey: "serialnumber")
        newManagedObject.setValue("", forKey: "comment")
        newManagedObject.setValue("", forKey: "imagepath")

        
        
        
    }
    
    func insertNewDistanceObject(newManagedObject: Distance) {
        
        let locastr=NSLocalizedString("Distance", comment:"data")
        
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "name")
        newManagedObject.setValue("", forKey: "comment")
        newManagedObject.setValue("m", forKey: "unit")
        
        let entityDescription = NSEntityDescription.entityForName("Hausse", inManagedObjectContext:DataManager.getContext())

         let c = ["5","10","15","18","20","30","40","50","60","70"]
        
        for distance in c {
            
        
            let hausse = Hausse(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
        
            hausse.name = distance
            hausse.hausse = "0"
            hausse.relationship = newManagedObject
            
            newManagedObject.relationship.addObject(hausse)
            
        }

        
        // println(newManagedObject.allHaussesDescription())
    }

    func insertNewTirObject(newManagedObject: Tir) {
        let locastr=NSLocalizedString("Au club", comment:"data")
        
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "location")
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

    func insertNewFlecheObject(newManagedObject: AnyObject) {
        
        let locastr=NSLocalizedString("Lot de flêches", comment:"data")
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "name")
        newManagedObject.setValue("", forKey: "feather")
        newManagedObject.setValue("", forKey: "comment")
        newManagedObject.setValue("", forKey: "point")
        newManagedObject.setValue(0.0, forKey: "length")
        newManagedObject.setValue(0, forKey: "spin")
        
        
    }

    
    func insertNewObject(sender: AnyObject) {
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! NSManagedObject
        
        
        switch tablename{
            
        case "Materiel":
            insertNewMatosObject(newManagedObject)

        case "Distance":
              insertNewDistanceObject(newManagedObject as! Distance)

            
        case "Tir":
              insertNewTirObject(newManagedObject as! Tir)
        
        case "Fleche":
            insertNewFlecheObject(newManagedObject)
            
        default: break


        }

        
        
        
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
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "materielSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailEditMaterielViewController
                
                controller.context  =  self.fetchedResultsController.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if (segue.identifier == "flecheSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailEditFlecheViewController
                
                controller.context  =  self.fetchedResultsController.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if (segue.identifier == "distanceSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Distance
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailEditDistanceViewController
                
                controller.context  =  self.fetchedResultsController.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if (segue.identifier == "tirSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tir
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailEditTirViewController
                // controller.context  = self.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if (segue.identifier == "blason" ){
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tir
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! TargetController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }

        
        
        
        
        
        
        
        
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }else{
//            if segue.identifier == "webview" {
//                if let indexPath = self.tableView.indexPathForSelectedRow() {
//                    let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
//                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WebViewController
//                    controller.detailItem = object
//                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                    controller.navigationItem.leftItemsSupplementBackButton = true
//                }
//            }
//        }
    }
    
    // MARK: - Table View
    
    
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)-> CGFloat{
    
    
    switch tablename{
    case "Tir":
        return 100
    case "Distance":
        
        return 161
     default:
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var  ii = self.fetchedResultsController.sections?.count
        
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        switch tablename{
            
            case "Materiel":
                let cell = tableView.dequeueReusableCellWithIdentifier("matoscell", forIndexPath: indexPath) as! MatosCell
                self.configureMatosCell(cell, atIndexPath: indexPath)
                return cell
            case "Distance":
            
                let cell = tableView.dequeueReusableCellWithIdentifier("distancecell", forIndexPath: indexPath) as! DistanceCell
                    self.configureDistanceCell(cell, atIndexPath: indexPath)
                return cell

            case "Tir":
                let cell = tableView.dequeueReusableCellWithIdentifier("tircell", forIndexPath: indexPath) as! TirCell
                self.configureTirCell(cell, atIndexPath: indexPath)
                return cell
            
            case "Fleche":
            let cell = tableView.dequeueReusableCellWithIdentifier("flechecell", forIndexPath: indexPath) as! FlecheCell
            self.configureFlecheCell(cell, atIndexPath: indexPath)
            return cell
            
            
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
       
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                let context = self.fetchedResultsController.managedObjectContext
                context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
    
                var error: NSError? = nil
                if !context.save(&error) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //println("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
        }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        cell.textLabel!.text = object.valueForKey("name")!.description
    }
    func configureMatosCell(cell: MatosCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        cell.matos!.text = object.valueForKey("name")!.description
        cell.serialnumber!.text = object.valueForKey("serialnumber")!.description
    }
    
    func configureDistanceCell(cell: DistanceCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Distance

        cell.nom!.text = object.valueForKey("name")!.description
        cell.detailItem = object.getAllHaussesSorted()
        
        
    }
    
    func configureTirCell(cell: TirCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tir
        cell.nom!.text=object.valueForKey("location")!.description
        cell.distance!.text=object.valueForKey("distance")!.description
        cell.total!.text = object.getTotal().description
        
        
        let cframe: CGRect = CGRect(x: cell.contentView.frame.width-100 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
        
        
        //let b:UIButton = UIButton(frame:cframe)
        let b:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        b.frame = CGRect(x: cell.contentView.frame.width-100 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
        b.backgroundColor = UIColor.whiteColor()
        let locastr=NSLocalizedString("Blason", comment:"data")
        
        b.setTitle( locastr, forState: .Normal)
        b.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        b.addTarget(self, action: "pressedBlason:", forControlEvents: .TouchUpInside)
        b.tag = indexPath.row
        cell.contentView.addSubview(b)

        
        
    }

    func configureFlecheCell(cell: FlecheCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        cell.nom!.text = object.valueForKey("name")!.description
        cell.spin!.text = object.valueForKey("spin")!.description

    }

    
    
    func pressedBlason(sender: UIButton!) {
        
       let idx =  NSIndexPath(forRow: sender.tag, inSection: 0)
        self.tableView.selectRowAtIndexPath(idx, animated: false, scrollPosition: UITableViewScrollPosition.None)
        
        
       performSegueWithIdentifier("blason", sender: self)
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            switch tablename{
                
            case "Materiel":
                self.configureMatosCell(tableView.cellForRowAtIndexPath(indexPath!) as! MatosCell, atIndexPath: indexPath!)
            case "Distance":
                
                self.configureDistanceCell(tableView.cellForRowAtIndexPath(indexPath!) as! DistanceCell, atIndexPath: indexPath!)
                
            case "Tir":
                self.configureTirCell(tableView.cellForRowAtIndexPath(indexPath!) as! TirCell, atIndexPath: indexPath!)
                
            case "Fleche":
                self.configureFlecheCell(tableView.cellForRowAtIndexPath(indexPath!) as! FlecheCell, atIndexPath: indexPath!)
                
                
            default:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            }

            
            
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }

    */
    
    

    
    

    }