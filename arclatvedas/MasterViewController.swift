//
//  MasterViewController.swift
//  arclatvedas
//
//  Created by divol on 23/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData

import CoreDataProxy

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    enum Table: Int {
        case Infos = 0, Mandats, Photos, Materiel,Fleches,Charte, Distances, Scores, Apropos
    }
    
    
    var detailViewController: DetailViewController? = nil
   // var managedObjectContext: NSManagedObjectContext? = nil
    
    // MARK: - Fetched results controller
    
    var fetchedResultsEventController: NSFetchedResultsController {
        if _fetchedResultsForEventController != nil {
            return _fetchedResultsForEventController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: DataManager.getContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "ordre", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsForEventController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsForEventController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsForEventController!
    }
    var _fetchedResultsForEventController: NSFetchedResultsController? = nil
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        // Do any additional setup after loading the view, typically from a nib.
        //        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //
        //        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewEventObject:")
        //        self.navigationItem.rightBarButtonItem = addButton
        
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }
    //CharteViewController
    override func viewWillAppear(animated: Bool){
        let sectionInfo = self.fetchedResultsEventController.sections![0] as! NSFetchedResultsSectionInfo
        let compte = sectionInfo.numberOfObjects
        
        
        
        if (compte == 0){
            self.initNewEventObject("Les informations",url:"http://arclatvedas.free.fr/index.php?option=com_content&view=article&id=194&tmpl=component",ordre:Table.Infos.rawValue + 1)
            self.initNewEventObject("Les mandats",url:"http://arclatvedas.free.fr/index.php?option=com_content&view=article&id=228&tmpl=component",ordre:Table.Mandats.rawValue + 1)
            self.initNewEventObject("Photos",url:"https://www.flickr.com/photos/arclatvedas/",ordre:Table.Photos.rawValue + 1)
            self.initNewEventObject("Matériel",url:"",ordre:Table.Materiel.rawValue + 1)
            self.initNewEventObject("Flèches",url:"",ordre:Table.Fleches.rawValue + 1)
            self.initNewEventObject("Sélecteur de flèche",url:"",ordre:Table.Charte.rawValue + 1)

            self.initNewEventObject("Distances",url:"",ordre:Table.Distances.rawValue + 1)
            self.initNewEventObject("Scores",url:"",ordre:Table.Scores.rawValue + 1)
            self.initNewEventObject("À propos d'Arc Lat'Védas",url:"http://arclatvedas.free.fr/index.php?option=com_content&view=article&id=20&tmpl=component",ordre:Table.Apropos.rawValue + 1)
            
        }else{
              //if (compte == 8){
                //ajout d'un calcul de spin
               //  self.initNewEventObject("Sélecteur de flèche",url:"",ordre:Table.Charte.rawValue + 1)
                
                //mise a jour des indexs
                var count = 0
                for event in self.fetchedResultsEventController.fetchedObjects as! [NSManagedObject] {

                    
                    event.setValue(count, forKey: "ordre")
                    count++
                }
                let context = self.fetchedResultsEventController.managedObjectContext

                var error: NSError? = nil
                if !context.save(&error) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //println("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }

                
            // }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initNewEventObject(name:String, url:String, ordre : Int) {
        let context = self.fetchedResultsEventController.managedObjectContext
        let entity = self.fetchedResultsEventController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! NSManagedObject
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue(name, forKey: "name")
        newManagedObject.setValue(url, forKey: "url")
        newManagedObject.setValue(ordre, forKey: "ordre")
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }
    
    
    
    func insertNewEventObject(sender: AnyObject) {
        let context = self.fetchedResultsEventController.managedObjectContext
        let entity = self.fetchedResultsEventController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! NSManagedObject
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue("", forKey: "name")
        newManagedObject.setValue("", forKey: "url")
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
        
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else{
            if segue.identifier == "webview" {
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WebViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }else {
                if segue.identifier == "matos" {
                    if let indexPath = self.tableView.indexPathForSelectedRow() {
                        //let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
                        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ListeViewController
                        
//                        controller.managedObjectContext=self.managedObjectContext;
                        
                        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                        
                        controller.navigationItem.leftItemsSupplementBackButton = true
                        let row:Table = Table(rawValue: indexPath.row)!
                        
                        switch (row ){
                        case Table.Materiel:
                            controller.tablename="Materiel"
                        case Table.Fleches:
                            controller.tablename="Fleche"
                        case Table.Distances:
                            controller.tablename="Distance"
                        case Table.Scores:
                            controller.tablename="Tir"
                        default:
                            controller.tablename=""
                        }
                        
                        
                    }
                    
                    
                } else {
                    if segue.identifier == "statistique" {
                        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! StatistiqueViewController
//                        controller.managedObjectContext=self.managedObjectContext;
                        
                        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                        
                        controller.navigationItem.leftItemsSupplementBackButton = true
                        
                        controller.tablename="Tir"
                        
                    } else {
                        
                        if segue.identifier == "charteSegue" {
                            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CharteViewController
                            //                        controller.managedObjectContext=self.managedObjectContext;
                            
                            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                            
                            controller.navigationItem.leftItemsSupplementBackButton = true
                            
                            controller.tablename="SpinCharte"
                            
                        }
                        
                    }
                }
                
            }
            
            
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var  ii = self.fetchedResultsEventController.sections?.count
        
        return self.fetchedResultsEventController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsEventController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        
        
        if indexPath.row ==  Table.Scores.rawValue {
            let cframe: CGRect = CGRect(x: cell.contentView.frame.width-100 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
            
            
            //let b:UIButton = UIButton(frame:cframe)
            let b:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            b.frame = CGRect(x: cell.contentView.frame.width-100 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
            b.backgroundColor = UIColor.whiteColor()
            b.setTitle( "Graph", forState: .Normal)
            b.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
            b.addTarget(self, action: "pressedStat:", forControlEvents: .TouchUpInside)
            
            cell.contentView.addSubview(b)

        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        let row:Table = Table(rawValue: indexPath.row)!
        //case Infos = 0, Mandats, Photos, Materiel,Fleches, Distances, Scores, Apropos
        
        switch (row ){
            
        case .Infos,.Mandats,.Photos,.Apropos:
            
            self.performSegueWithIdentifier("webview", sender: self)
            
        case .Materiel:
            self.performSegueWithIdentifier("matos", sender: self)
        case .Fleches:
            self.performSegueWithIdentifier("matos", sender: self)
        case .Charte:
            self.performSegueWithIdentifier("charteSegue", sender: self)
        case .Distances:
            self.performSegueWithIdentifier("matos", sender: self)
        case .Scores:
            self.performSegueWithIdentifier("matos", sender: self)
        
        default:
            let page :String = object.valueForKey("url")!.description
            if (!page.isEmpty){
                self.performSegueWithIdentifier("webview", sender: self)
            }
            
        }
        
        
    }
    
    func pressedStat(sender: UIButton!) {
        
        
        performSegueWithIdentifier("statistique", sender: self)
    }
    //    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == .Delete {
    //            let context = self.fetchedResultsController.managedObjectContext
    //            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
    //
    //            var error: NSError? = nil
    //            if !context.save(&error) {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                //println("Unresolved error \(error), \(error.userInfo)")
    //                abort()
    //            }
    //        }
    //    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
        cell.textLabel!.text = object.valueForKey("name")!.description
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
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation:.Automatic)

           // self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
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

