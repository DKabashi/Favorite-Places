//
//  MKMapViewExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import UIKit
import MapKit

extension MKMapView {
    func centerToLocation(
       _ location: CLLocation,
       regionRadius: CLLocationDistance = 200
     ) {
       let coordinateRegion = MKCoordinateRegion(
         center: location.coordinate,
         latitudinalMeters: regionRadius,
         longitudinalMeters: regionRadius)
       setRegion(coordinateRegion, animated: true)
     }
    
}
