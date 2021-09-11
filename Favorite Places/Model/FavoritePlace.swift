//
//  FavoritePlace.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import Foundation
import MapKit

class FavoritePlace: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
