//
//  MapViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import UIKit
import RxCocoa
import RxSwift

class MapViewController: UIViewController {
    let authenticationManager = AuthenticationManager()
    let mapView = MapView()
    let helpButton = FavoritePlacesButton(style: .squareWithImage)
    let userButton = FavoritePlacesButton(style: .squareWithImage)
    let locationButton = FavoritePlacesButton(style: .squareWithImage)
    let favoritePlacesButton = FavoritePlacesButton(style: .squareWithImage)
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        observeUserState()
        setupHelpButton()
        setupUserButton()
        setupLocationButton()
        setupFavoritePlacesButton()
        observeAddFavoritePlaceRequest()
    }
    
    private func setupMapView() {
        view.add(mapView)
        mapView.pinToEdges(of: view)
    }
    
    private func observeUserState() {
        authenticationManager.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success(user: let user):
                let didLogout = user == nil
                if didLogout {
                    self.switchRootViewController()
                }
            case .fail(error: let error):
                print("User creation failed: \(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupHelpButton() {
        mapView.add(helpButton)
        helpButton.setImage(.help, for: .normal)
        helpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .padding * 4).isActive = true
        helpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        helpButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupUserButton() {
        mapView.add(userButton)
        userButton.setImage(.person, for: .normal)
        userButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .padding * 4).isActive = true
        userButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        userButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupLocationButton() {
        mapView.add(locationButton)
        locationButton.setImage(.locationOff, for: .normal)
        locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.padding * 4).isActive = true
        locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupFavoritePlacesButton() {
        mapView.add(favoritePlacesButton)
        favoritePlacesButton.setImage(.favorites, for: .normal)
        favoritePlacesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.padding * 4).isActive = true
        favoritePlacesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        favoritePlacesButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        favoritePlacesButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func observeAddFavoritePlaceRequest() {
        mapView.annotationRequestWithCoordinates.subscribe(onNext: { [weak self] coordinates in
            guard let self = self else { return }
            let addFavoritePlaceVC = AddFavoritePlaceViewController()
            self.present(addFavoritePlaceVC, animated: true)
        }).disposed(by: disposeBag)
    }
}
