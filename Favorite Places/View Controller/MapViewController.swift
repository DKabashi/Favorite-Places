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
    let signOutButton = UIButton()
    let authenticationManager = AuthenticationManager()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(signOutButton)
        signOutButton.frame = CGRect(x: 20, y: 40, width: 200, height: 100)
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.setTitleColor(.red, for: .normal)
        
        signOutButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.authenticationManager.signOut()
        }).disposed(by: disposeBag)
        observeUserState()
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
