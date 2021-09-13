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
    
    private let persistanceManager = PersistenceManager()
    private var locationManager: CLLocationManager?
    private let disposeBag = DisposeBag()
    
    let annotationRequestWithCoordinates = PublishRelay<CLLocationCoordinate2D>()
    let selectedFavoritePlace = PublishRelay<FavoritePlace>()
    let deniedLocationAuthorizaton = PublishRelay<Bool>()
    
    init(isEditing: Bool = false) {
        super.init(frame: .zero)
        setupMap()
        if !isEditing {
            goToInitialLocation()
            loadMapWithAnnotations()
            observeNewAnnotationRequest()
            setupLocationManager()
            checkLocationAuthorization()
            observeSelectedFavoritePlace()
        } else {
            observeNewLocationTap()
        }
    }
    
    private func setupMap() {
        isRotateEnabled = false
        delegate = self
    }
    
    private func goToInitialLocation() {
        let initialLocation = CLLocation(latitude: 42.65526675518743, longitude: 21.1804951825126)
        centerToLocation(initialLocation)
    }
    
    func goToLocationForEditMode(favoritePlace: FavoritePlace) {
        addAnnotation(favoritePlace)
        centerToLocation(CLLocation(latitude: favoritePlace.latitude, longitude: favoritePlace.longitude))
    }
    
    func loadMapWithAnnotations() {
        persistanceManager.retrieveFavorites { result in
            switch result {
            case .success(let favoritePlaces):
                self.annotations.forEach {
                    self.removeAnnotation($0)
                }
                
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
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }
    
    private func observeSelectedFavoritePlace() {
        selectedFavoritePlace.subscribe(onNext: { [weak self] favoritePlace in
            guard let self = self else { return }
            let favoritePlaceLocation = CLLocation(latitude: favoritePlace.latitude, longitude: favoritePlace.longitude)
            self.centerToLocation(favoritePlaceLocation)
        }).disposed(by: disposeBag)
    }
    
     func goToUserLocation() {
        if locationManager == nil {
            setupLocationManager()
        }
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .denied || authorizationStatus == .notDetermined {
            deniedLocationAuthorizaton.accept(true)
            return
        }
     
        if let location = locationManager?.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
            setRegion(region, animated: true)
        }
    }
    
    private func observeNewLocationTap() {
        observeTap().subscribe(onNext: { [weak self] tap in
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
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "favoritePlacesAnnotation")
        annotationView.markerTintColor = .customLightBlue
        annotationView.clusteringIdentifier = "favoritePlacesCluster"
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
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let userLocation = mapView.view(for: mapView.userLocation)
        userLocation?.isEnabled = false
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            showsUserLocation = true
            goToUserLocation()
            locationManager?.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
}
