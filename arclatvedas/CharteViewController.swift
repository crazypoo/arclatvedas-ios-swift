//
//  CharteViewController.swift
//  arclatvedas
//
//  Created by divol on 17/06/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import CoreDataProxy

class CharteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var taille: UITextField!
    @IBOutlet weak var puissance: UITextField!
    @IBOutlet weak var chercher: UIButton!
    
    
    var results:NSFetchedResultsController {
        var realTaille = 0
        var realweight = 0
        
        
        if _fetched != nil {
            return _fetched!
        }

        
        if let lataille =  taille.text.toInt(){
            realTaille=lataille
        }
        
        if let lapuissance =  puissance.text.toInt(){
            realweight=lapuissance
        }
        _fetched = SpinCharteLoader.getGroupes(realTaille,weight:realweight)
        return _fetched!
    }
    var _fetched:NSFetchedResultsController? = nil
    
    var tablename:String = "[Unnamed]" {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        switch tablename{
            
        case "SpinCharte":
            self.navigationItem.title = "Sélecteur de flèche"
            
        default: break
            
            
        }
        
        
        
    }

    
    
   @IBAction func cherche(sender: UIButton) {

     taille.resignFirstResponder()
     puissance.resignFirstResponder()

    _fetched = nil
    
    
        tableview.reloadData()
    }

    
    
//    for (var i = 0 ; i<result.fetchedObjects!.count ; i++){
//    let indexPath:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
//    
//    let toto = result.objectAtIndexPath( indexPath) as! SpinCharte
//    let spinGroupe = toto.group.objectAtIndex(0) as! SpinGroupe
//    NSLog(spinGroupe.name);
//    
//    NSLog( "count = \(spinGroupe.arrowsofgroup.count)")
//    for (var j = 0 ; j < spinGroupe.arrowsofgroup.count ; j++){
//    
//    let arrow = spinGroupe.arrowsofgroup.objectAtIndex(j) as! SpinFleche;
//    NSLog(arrow.modele);
//    
//    }
//    
//    
//    }

    
    //MARK: tabledatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return results.fetchedObjects!.count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
            let indexPath:NSIndexPath = NSIndexPath(forRow: section, inSection: 0)
        
            let toto = results.objectAtIndexPath( indexPath) as! SpinCharte
            let spinGroupe = toto.group.objectAtIndex(0) as! SpinGroupe
        
            return spinGroupe.name

    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            let indexPath:NSIndexPath = NSIndexPath(forRow: section, inSection: 0)
        
            let toto = results.objectAtIndexPath( indexPath) as! SpinCharte
           let spinGroupe = toto.group.objectAtIndex(0) as! SpinGroupe

        return spinGroupe.arrowsofgroup.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("arrowChooser", forIndexPath: indexPath) as! ArrowChooserCell
        
        let aindexPath:NSIndexPath = NSIndexPath(forRow: indexPath.section, inSection: 0)
        
        let toto = results.objectAtIndexPath( aindexPath) as! SpinCharte
        let spinGroupe = toto.group.objectAtIndex(0) as! SpinGroupe
        let arrow = spinGroupe.arrowsofgroup.objectAtIndex(indexPath.row) as! SpinFleche;
        
        cell.arrow = arrow
        return cell;
    }
    

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
