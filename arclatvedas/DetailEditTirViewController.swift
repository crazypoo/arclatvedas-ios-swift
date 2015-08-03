//
//  DetailEditTirViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import CoreDataProxy

class DetailEditTirViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,
                                    UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LineChartDelegate
    {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var totalLabel : UILabel!
    
    
    
    var label = UILabel()
    var lineChart: LineChart!

     @IBOutlet weak var statview: UIView!
    
    
    private let reuseIdentifier = "scoreButtons"
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    
    
    let distances = ["5","10","15","18","20","25","30","40","50","60","70"]
    let valeurs = ["X","10","9","8","7","6","5","4","3","2","1","M"]
    let colors = [UIColor.yellowColor(),UIColor.yellowColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.redColor(),UIColor.blueColor(),UIColor.blueColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor()]
    
    
     let textcolors = [UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),
                UIColor.blackColor(),UIColor.blackColor(),
                UIColor.whiteColor(),UIColor.whiteColor(),
                UIColor.whiteColor(),UIColor.whiteColor(),
                UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor()]
    
    
    
     let tags = [100,10,9,8,7,6,5,4,3,2,1,0]
    

   // var context : AnyObject?
    
    
    let NOMBREMAX : Int = 6
    var curVolee:Volee?
    var curCount:Int = -1
    
    
    var detailItem: Tir? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveObject:")
//        self.navigationItem.rightBarButtonItem = saveButton
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editObject:")
        self.navigationItem.rightBarButtonItem = editButton

        
        // Do any additional setup after loading the view.
        self.collection.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        
        
       
        
        self.configureView()
        
        
        tableview.layer.borderColor = UIColor.darkGrayColor().CGColor
        tableview.layer.borderWidth = 1.0;
        tableview.layer.cornerRadius = 0;
        tableview.clipsToBounds=true;

        
        
        
    }
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Tir = self.detailItem {
            self.navigationItem.title = detail.location + ":" + detail.distance
            
            totalLabel?.text = detail.getTotal().description
            
            

            
             if let detail: Tir = self.detailItem {
                if detail.volees.count > 0 {
                    
                    
                    self.curVolee = detail.volees.lastObject as! Volee
                    curCount = detail.volees.count-1
                }else{
                    curVolee = createEmptyVolee()
                    saveObject(self)
                    curCount = 0
                }
            }
        }
    }
    
    func editObject (sender: AnyObject) {
        if let detail: Tir = self.detailItem {
            var alert = UIAlertController(title: "Edit", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                
                var texts = alert.textFields as! [UITextField]
               for (var i = 0 ; i < texts.count ; i++){
                
                    let textField: UITextField = texts[i]
                    if textField.placeholder == "Localication:" {
                    
                        if let detail: Tir = self.detailItem {
                            
                            detail.setValue(textField.text, forKey: "location")
                        }

                    }else {
                         detail.setValue(textField.text, forKey: "distance")
                        
                    }
                
                }
                self.saveObject(self)
                self.navigationItem.title = detail.location + ":" + detail.distance

            }))
            let locastr=NSLocalizedString("Cancel", comment:"data")
            alert.addAction(UIAlertAction(title: locastr, style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!)  in
                textField.placeholder = "Localication:"
                textField.secureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                     textField.text = detail.location
                }
            })
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!)  in
                textField.placeholder = "Distance:"
                textField.keyboardType = .DecimalPad
                textField.secureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                    textField.text = detail.distance
                }

            })
            
                
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func saveObject(sender: AnyObject) {
        if let detail: Tir = self.detailItem {
            
            
            self.view.resignFirstResponder()
            
//            let dateFormat:NSDateFormatter = NSDateFormatter()
//            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
//            dateFormat.dateFormat="dd-MM-yy"
//            let ladate :NSDate = dateFormat.dateFromString("")!
//            
            
            DataManager.saveManagedContext()
//            if let cont:AnyObject = self.context {
//                var error: NSError? = nil
//                if !cont.save(&error) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    //println("Unresolved error \(error), \(error.userInfo)")
//                    abort()
//                }
//                
//            }
            
            if let detail: Tir = self.detailItem {
                totalLabel?.text = detail.getTotal().description
            }
            
        }
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
    
    
    // MARK: Tableview ds
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detail: Tir = self.detailItem {
            return detail.volees.count
        }
        
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("voleeCell") as! UITableViewCell
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//        for  (var i = 0 ; i < cell.contentView.subviews.count ; i++ ){
//            
//            let v:UIView = cell.contentView.subviews[i] as! UIView
//             v.removeFromSuperview()
//        }
       
         let detail: Tir = self.detailItem!
        

       
        let vol: Volee =  detail.volees.objectAtIndex(indexPath.row) as! Volee
        
        let rect = CGRect(x: 5 ,y: 9 ,width: 30, height:21)
        
        let label:UILabel = UILabel(frame: rect)
        label.text = (indexPath.row + 1).description
        label.backgroundColor = UIColor.grayColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        
        label.layer.borderColor = UIColor.darkGrayColor().CGColor
        label.layer.borderWidth = 1.0;
        label.layer.cornerRadius = 8;
        label.clipsToBounds=true;

        
        label.textAlignment = .Center
        
        
        cell.contentView.addSubview(label)
        
        
        for (var i = 0 ; i < NOMBREMAX ; i++){
            //une constante pour le 6 !!
            let points:Int = vol.getAt(i)
            
            if points >= 0 {
                let x = 65 + (30 * i)
                
                let rect = CGRect(x: x ,y: 9 ,width: 30, height:21)
                
                let label:UILabel = UILabel(frame: rect)
                
                if points == 100 {
                    label.text = "X"
                }else  if points == 0 {
                    label.text = "M"

                } else {
                    label.text = points.description

                }
                label.textAlignment = .Center
                if i % 2 == 0 {
                    label.backgroundColor = UIColor.whiteColor()
                    
                }else {
                    label.backgroundColor = UIColor.lightGrayColor()
                }

                
                 cell.contentView.addSubview(label)
            }
            
         
        
        }

        
        
        
        
        return cell;
    }

     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let detail: Tir = self.detailItem {
                DataManager.deleteManagedObject(detail.volees.objectAtIndex(indexPath.row) as! NSManagedObject)
//                self.context!.deleteObject(detail.volees.objectAtIndex(indexPath.row) as! NSManagedObject)
               // detail.volees.removeObjectAtIndex(indexPath.row)
                self.curCount--
//                if self.curCount >= 0 {
//                    self.curVolee = detail.volees.lastObject as! Volee
//                } else {
//                    self.curVolee = nil
//                }
                
            }
            saveObject(self)
            if let detail: Tir = self.detailItem {
                
                if self.curCount >= 0 {
                    self.curVolee = detail.volees.lastObject as! Volee
                } else {
                    self.curVolee = nil
                }
                
            }


            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            

            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
                dispatch_async(dispatch_get_main_queue()) { // 2
                    self.tableview.reloadData()
                }
            }


            
            
        }
    }

    
    
    
    // MARK: pickerView ds
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return distances.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return distances[row]
    }
    


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return valeurs.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier , forIndexPath:indexPath) as! UICollectionViewCell
        
         let cframe: CGRect = CGRect(x: 0 ,y: 0 ,width: cell.frame.width, height:cell.frame.height)
        
        
        let b:UIButton = UIButton(frame:cframe)
        
           // b.backgroundColor = UIColor.whiteColor()
        let c : UIColor = colors[indexPath.item]
             b.backgroundColor = c
        
            b.tag = tags[indexPath.item]
            b.setTitle( valeurs[indexPath.item], forState: .Normal)
//            b.setTitleColor(UIColor.blackColor(), forState: .Normal)
            b.setTitleColor(textcolors[indexPath.item], forState: .Normal)

            b.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        cell.addSubview(b)
        return cell
    }
    
 @IBAction func pressed(sender: UIButton!) {
    
    switch sender.tag {
        case 1000 :
        
            curVolee?.deleteLast();
            
            saveObject(self)
            tableview.reloadData()

        break
        
       
        case 2000 :
              if let vol: Volee = self.curVolee {
                    if ((vol.getTaille() == NOMBREMAX)  || (vol.getTaille() == 3)) {
                        
                         saveObject(self)
                        
                        curVolee = createEmptyVolee()
                        
                         saveObject(self)
                        
                         if let detail: Tir = self.detailItem {
                        
                        curCount =  detail.volees.count-1
                            }
                        
                    }
              }
            if self.detailItem!.volees.count == 0 {
                curVolee = createEmptyVolee()
                
                saveObject(self)
                
                curCount=0

            }
            tableview.reloadData()

    case 3000 :
        UIView.transitionWithView(self.statview, duration: 0.325, options: .TransitionFlipFromLeft | .CurveEaseInOut, animations: { () -> Void in
            if  self.statview.alpha == 0.0 {
                if let detail: Tir = self.detailItem {
                    
                    if detail.volees.count > 1 {
                        self.buildChart()
                        self.statview.alpha=1.0
                        self.tableview.alpha=0.0
                    }
                
                }
            }else{
                self.statview.alpha=0.0
                self.tableview.alpha=1.0
            }
            
        }, completion: { (Bool) -> Void in
            
        })
        
        
        default :
            curVolee?.addScore(sender.tag, impact:CGPointMake(0,0),zone:CGPointMake(0,0));
            saveObject(self)
            tableview.reloadData()
    }
    var index: NSIndexPath  = NSIndexPath(forRow: curCount, inSection: 0)
    tableview.scrollToRowAtIndexPath(index, atScrollPosition:.None, animated: true)

    }

    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            
            return CGSize(width: 46, height: 30)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func createEmptyVolee() -> Volee {
        
        
 
        
        let entityDescription = NSEntityDescription.entityForName("Volee", inManagedObjectContext: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertIntoManagedObjectContext: DataManager.getContext())
        
        volee.setValue("[]", forKey: "volee")
        volee.setValue(detailItem!, forKey: "relationship")
        volee.setValue(0 ,forKey: "rang")
        
        
        
        detailItem!.volees.addObject(volee)
        
        return volee
    }
    
    
    
    
    func buildChart() {
        
//        var lineChart: LineChart!

        var views: [String: AnyObject] = [:]
        self.statview!.backgroundColor = UIColor.whiteColor()
        
        
        label.text = "..."
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = NSTextAlignment.Center
        self.statview.addSubview(label)
        views["label"] = label
        self.statview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
        self.statview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: nil, metrics: nil, views: views))
        
        // simple arrays
        var data: [CGFloat] = []
        var data2: [CGFloat] = []
        
        // simple line with custom x axis labels
        var xLabels: [String] = []
        
        if let detail: Tir = self.detailItem {
            for (var j = 0 ; j < detail.volees.count ; j++){
                let vol: Volee =  detail.volees.objectAtIndex(j) as! Volee
                let f:CGFloat = CGFloat(vol.getTotal())
                data.append(CGFloat(vol.getTotal()))
                var localtotal = 0
                var localcount = 0

                for (var i = 0 ; i < NOMBREMAX ; i++){
                    
                    let points:Int = vol.getAt(i)
                    if points >= 0 {
                        
                        localcount++
                        if points == 100 {
                           localtotal += 10
                        }else  if points == 0 {
                            
                        } else {

                            localtotal += points
                        }

                    }
                    
                        
                }
                if localcount != 0 {
                 data2.append( CGFloat(localtotal / localcount))
                }else{
                    data2.append(0)

                }
                xLabels.append("\(j+1)")
            }
        }
        lineChart = LineChart()
        lineChart!.backgroundColor = UIColor.whiteColor()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        
        lineChart.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineChart.delegate = self
        self.statview.addSubview(lineChart)
        views["chart"] = lineChart
        self.statview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[chart]-0-|", options: nil, metrics: nil, views: views))
        
        self.statview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: nil, metrics: nil, views: views))
        
        
        
        
    }
    
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "Volée: \(Int(x+1))     (Score,Moy): \(yValues)"
    }
    
    
    
    /**
    * Redraw chart on device rotation.
    */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

    
    
}