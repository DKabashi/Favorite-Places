//
//  MapView.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import MapKit
import RxSwift
import RxRelay

class MapView: MKMapView {
    private let disposeBag = DisposeBag()
    private let persistanceManager = PersistenceManager()
    let annotationRequestWithCoordinates = PublishRelay<CLLocationCoordinate2D>()
    
    init() {
        super.init(frame: .zero)
        setupMap()
        loadMapWithAnnotations()
        observeNewAnnotationRequest()
    }
    
    private func setupMap() {
        let initialLocation = CLLocation(latitude: 42.65526675518743, longitude: 21.1804951825126)
        centerToLocation(initialLocation)
        delegate = self
    }
    
    private func loadMapWithAnnotations() {
        persistanceManager.retrieveFavorites { result in
            switch result {
            case .success(let favoritePlaces):
                favoritePlaces.forEach {
                    if $0.user.email == AuthenticationManager.currentUser?.email ?? "" {
                        self.addAnnotation($0)
                    }
                }
            default: return
            }
        }
    }
    
    private func observeNewAnnotationRequest() {
        observeLongPress().subscribe(onNext: { [weak self] tap in
            guard let self = self else { return }
            let location = tap.location(in: self)
            let coordinate = self.convert(location, toCoordinateFrom: self)
            self.annotationRequestWithCoordinates.accept(coordinate)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "favoritePlacesAnnotation")
        annotationView.markerTintColor = .customLightBlue
        if let annotation = annotation as? FavoritePlace, let image = UIImage(data: annotation.imageData) {
            annotationView.canShowCallout = true
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.contentMode = .scaleAspectFit
            annotationView.detailCalloutAccessoryView = imageView
        }
        return annotationView
    }
}
