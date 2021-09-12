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
    private let authenticationManager = AuthenticationManager()
    private let mapView = MapView()
    private let helpButton = FavoritePlacesButton(style: .squareWithImage)
    private let userButton = FavoritePlacesButton(style: .squareWithImage)
    private let locationButton = FavoritePlacesButton(style: .squareWithImage)
    private let favoritePlacesButton = FavoritePlacesButton(style: .squareWithImage)
    private let newFavoritePlace = PublishRelay<FavoritePlace>()
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
        observeNewFavoritePlaces()
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
        observeUserButtonTap()
    }
    
    private func observeUserButtonTap() {
        userButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.presentAlertWithTwoOptions(title: "Greetings", message: "Your email address is \(AuthenticationManager.currentUser!.email).", buttonTitle: "Continue", alternativeButtonTitle: "Sign out", buttonCallback: nil, alternativeButtonCallback: {
                self.authenticationManager.signOut()
            })
        }).disposed(by: disposeBag)
    }
    
    private func setupLocationButton() {
        mapView.add(locationButton)
        locationButton.setImage(.locationOn, for: .normal)
        locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.padding * 4).isActive = true
        locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        observeLocationButtonTap()
    }
    
    private func observeLocationButtonTap() {
        locationButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.mapView.goToUserLocation()
        }).disposed(by: disposeBag)
    }
    
    private func setupFavoritePlacesButton() {
        mapView.add(favoritePlacesButton)
        favoritePlacesButton.setImage(.favorites, for: .normal)
        favoritePlacesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.padding * 4).isActive = true
        favoritePlacesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        favoritePlacesButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        favoritePlacesButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        observeFavoritePlacesButtonTap()
    }
    
    private func observeFavoritePlacesButtonTap() {
        favoritePlacesButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.present(FavoritesListViewController(), animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func observeAddFavoritePlaceRequest() {
        mapView.annotationRequestWithCoordinates.subscribe(onNext: { [weak self] coordinates in
            guard let self = self else { return }
            let addFavoritePlaceVC = AddFavoritePlaceViewController()
            addFavoritePlaceVC.latitude = coordinates.latitude
            addFavoritePlaceVC.longitude = coordinates.longitude
            addFavoritePlaceVC.additionSucceededWithFavoritePlace.bind(to: self.newFavoritePlace).disposed(by: self.disposeBag)
            self.present(addFavoritePlaceVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func observeNewFavoritePlaces() {
        newFavoritePlace.subscribe(onNext: { [weak self] favoritePlace in
            guard let self = self else { return }
            self.mapView.addAnnotation(favoritePlace)
        }).disposed(by: disposeBag)
    }
}
