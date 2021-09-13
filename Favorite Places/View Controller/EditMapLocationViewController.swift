//
//  EditMapLocationViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/13/21.
//

import UIKit
import RxCocoa
import RxSwift

typealias Coordinate = (latitude: Double, longitude: Double)

class EditMapLocationViewController: UIViewController {
    private let titleLabel = FavoritePlacesLabel(type: .title)
    private let backButton = BackButton()
    private let mapView = MapView(isEditing: true)
    private let disposeBag = DisposeBag()
    private var favoritePlace: FavoritePlace!
    let newFavoritePlaceCoordination = PublishRelay<Coordinate>()
    
    init(favoritePlace: FavoritePlace) {
        super.init(nibName: nil, bundle: nil)
        self.favoritePlace = favoritePlace
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
        setupTitleLabel()
        setupMapView()
        observeNewLocationTapInMap()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupBackButton() {
        view.add(backButton)
        backButton.configure(parentView: view)
        observeBackButtonTap()
    }
    
    private func observeBackButtonTap() {
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupTitleLabel() {
        view.add(titleLabel)
        titleLabel.text = "Tap a place in map to update location"
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setupMapView() {
        view.add(mapView)
        mapView.pinToEdges(of: view, topPadding: 70)
        mapView.goToLocationForEditMode(favoritePlace: favoritePlace)
    }
    
    private func observeNewLocationTapInMap() {
        mapView.annotationRequestWithCoordinates.subscribe(onNext: { [weak self] coordinates in
            guard let self = self else { return }
            self.favoritePlace.latitude = coordinates.latitude
            self.favoritePlace.longitude = coordinates.longitude
            self.newFavoritePlaceCoordination.accept((latitude: coordinates.latitude, longitude: coordinates.longitude))
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
