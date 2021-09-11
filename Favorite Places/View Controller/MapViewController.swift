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
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        observeUserState()
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
}
