//
//  LieuViewController.swift
//  arclatvedas
//
//  Created by divol on 11/05/2016.
//  Copyright © 2016 jack. All rights reserved.
// INFO: https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

import UIKit
import MapKit





class LieuViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    
    var lieux = [LieuAnnotation]()

    
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("lieux", ofType: "json");
        //    var readError : NSError?
        var data: NSData?
        do {
            data = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        // 2
        //    var error: NSError?
        var jsonObject: AnyObject? = nil
        if let data = data {
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        // 3
        if let jsonObject = jsonObject as? [[String: String]] {
            for item in jsonObject {
                //print (item);
                
          //      [{"title":"Terrain","subtitle":"ALV-MMM","lat":"43.581268","long":"3.838444" },

                 let title:String = (item["title"])!
                let  subtitle:String = (item["subtitle"])!
                let latitude = ( (item["lat"])! as NSString).doubleValue
                let longitude = ((item["long"])! as NSString).doubleValue
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                let unlieu = LieuAnnotation(title: title,sub:subtitle, coordinate:coordinate)
                lieux.append(unlieu)


            }

        }
            // 4
    }
    
    
    
    
    
    let initialLocation = CLLocation(latitude: 43.567051, longitude: 3.898359)
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

    
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            
            self.navigationItem.title = NSLocalizedString(detail.valueForKey("name")!.description, comment:"data")
            
            
                   }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        
        centerMapOnLocation(initialLocation)
     //   let salle = LieuAnnotation(title: "Salle",sub:"", coordinate: CLLocationCoordinate2D(latitude: 43.567051, longitude: 3.898359))
        
      //  map.addAnnotation(salle)

        
        loadInitialData()
        map.addAnnotations(lieux)

        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

// MARK: MKMapViewDelegate
extension LieuViewController: MKMapViewDelegate {
    

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LieuAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure)
            }
            return view
        }
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! LieuAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }

}


