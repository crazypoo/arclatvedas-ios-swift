//
//  StatistiqueViewController.swift
//  arclatvedas
//
//  Created by divol on 18/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
import CoreDataProxy

class StatistiqueViewController: UIViewController, NSFetchedResultsControllerDelegate,LineChartDelegate, UIScrollViewDelegate {

    var label = UILabel()
    var lineChart: LineChart!
    //var scrollView: UIScrollView!
    
    
    //var managedObjectContext: NSManagedObjectContext? = nil
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> ()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: self.tablename, in: DataManager.getContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
       // let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil) //"Master"
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        do {
            try _fetchedResultsController!.performFetch()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    
    
    
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
        case "Tir":
            self.navigationItem.title = NSLocalizedString("Graphique", comment:"data")
            
        default: break
            
            
        }
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let cframe: CGRect = CGRect(x: 0 ,y: 0 ,width: view.frame.width, height:view.frame.height)
//
//        scrollView = UIScrollView(frame: cframe)
//        
        let results:[Tir] = fetchedResultsController.fetchedObjects as! [Tir]
        if results.count > 1 {
            var views: [String: AnyObject] = [:]
            
            label.text = "..."
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = NSTextAlignment.center
            self.view.addSubview(label)
            views["label"] = label
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
            
            // simple arrays
            var data: [CGFloat] = []
           // var data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
            
            // simple line with custom x axis labels
            var xLabels: [String] = [""]
            
            
            for j in 0 ..< results.count{
                
                let tir:Tir = results[j]
                
                data.append(CGFloat(tir.getTotal()))
                xLabels.append("\(j+1)")

                
            }
            
            
            lineChart = LineChart()
            lineChart.animation.enabled = true
            lineChart.area = true
            lineChart.x.labels.visible = true
            lineChart.x.grid.count = 5
            lineChart.y.grid.count = 5
            lineChart.x.labels.values = xLabels
            lineChart.y.labels.visible = true
            lineChart.addLine(data)
           // lineChart.addLine(data2)
            
            lineChart.translatesAutoresizingMaskIntoConstraints = false
            lineChart.delegate = self
            self.view.addSubview(lineChart)
            views["chart"] = lineChart
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))

        }

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
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
    * Redraw chart on device rotation.
    */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

}
