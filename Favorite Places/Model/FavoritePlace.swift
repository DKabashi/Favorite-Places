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
    let title: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
