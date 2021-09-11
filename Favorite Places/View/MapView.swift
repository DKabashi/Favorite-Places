//
//  MapView.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import MapKit
import RxSwift

class MapView: MKMapView {
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
    
        let initialLocation = CLLocation(latitude: 42.65526675518743, longitude: 21.1804951825126)
        centerToLocation(initialLocation)
        delegate = self
       
        for annotation in annotations {
            removeAnnotation(annotation)
        }
        
        observeLongPress().subscribe(onNext: { [weak self] tap in
            guard let self = self else { return }
            
            let location = tap.location(in: self)
            let coordinate = self.convert(location, toCoordinateFrom: self)
            
            let annotation = FavoritePlace(coordinate: coordinate)
            self.addAnnotation(annotation)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapView: MKMapViewDelegate {
   
}
