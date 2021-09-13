//
//  FavoritePlace.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import Foundation
import MapKit

class FavoritePlace: NSObject, Codable {
    let id: String
    var latitude: Double
    var longitude: Double
    var title: String?
    var imageData: Data
    let user: User
    
    init(title: String?, latitude: Double, longitude: Double, imageData: Data) {
        id = UUID().uuidString
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.imageData = imageData
        self.user = AuthenticationManager.currentUser ?? User(email: "")
    }
}

extension FavoritePlace: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
