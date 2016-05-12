//
//  LieuAnnotation.swift
//  arclatvedas
//
//  Created by divol on 11/05/2016.
//  Copyright © 2016 jack. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class LieuAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let titlesub:String?
    
    init(title: String, sub: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
         self.titlesub = sub
        super.init()
    }
    
    var subtitle: String? {
        return titlesub
    }
    
    func mapItem() -> MKMapItem {
        
        let addressDictionary = [String(CNPostalAddressStreetKey): self.subtitle!]

        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }

}
