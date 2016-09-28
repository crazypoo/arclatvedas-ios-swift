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
    @IBOutlet weak var utextview: UITextView!  // pour contourner un bug Apple de Localisation
    
    var _fetched:NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    
    var results:NSFetchedResultsController<NSFetchRequestResult> {
        var realTaille = 0
        var realweight = 0
        
        
        if _fetched != nil {
            return _fetched!
        }

        
        if let lataille =  Int(taille.text!){
            realTaille=lataille
        }
        
        if let lapuissance =  Int(puissance.text!){
            realweight=lapuissance
        }
        _fetched = SpinCharteLoader.getGroupes(NSNumber(value:realTaille),NSNumber(value:realweight))
        return _fetched!
    }
    
    
    var tablename:String = "[Unnamed]" {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        
        utextview?.text =  NSLocalizedString("blabla", comment:"data")
        switch tablename{
            
        case "SpinCharte":
            self.navigationItem.title = NSLocalizedString("Sélecteur de flèche", comment:"data")
            
        default: break
            
            
        }
        
        
        
    }

    
    
   @IBAction func cherche(_ sender: UIButton) {

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
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.fetchedObjects!.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
            let indexPath:IndexPath = IndexPath(row: section, section: 0)
        
            let toto = results.object( at: indexPath) as! SpinCharte
            let spinGroupe = toto.group.object(at: 0) as! SpinGroupe
        
            return spinGroupe.name

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            let indexPath:IndexPath = IndexPath(row: section, section: 0)
        
            let toto = results.object( at: indexPath) as! SpinCharte
           let spinGroupe = toto.group.object(at: 0) as! SpinGroupe

        return spinGroupe.arrowsofgroup.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arrowChooser", for: indexPath) as! ArrowChooserCell
        
        let aindexPath:IndexPath = IndexPath(row: (indexPath as NSIndexPath).section, section: 0)
        
        let toto = results.object( at: aindexPath) as! SpinCharte
        let spinGroupe = toto.group.object(at: 0) as! SpinGroupe
        let arrow = spinGroupe.arrowsofgroup.object(at: (indexPath as NSIndexPath).row) as! SpinFleche;
        
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
