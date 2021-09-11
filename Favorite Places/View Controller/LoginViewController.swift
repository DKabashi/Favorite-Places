//
//  LoginViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    private let authenticationView = AuthenticationView(isLogin: true)
    private let authenticationManager = AuthenticationManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAuthenticationView()
        observeSigninRequest()
        observeUserState()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupAuthenticationView() {
        view.add(authenticationView)
        authenticationView.pinToEdges(of: view, topPadding: .padding * 4, bottomPadding: .padding * 3)
    }
    
    private func observeSigninRequest() {
        authenticationView.authenticationRequestWithModel.subscribe(onNext: { [weak self] authModel in
            guard let self = self else { return }
            self.authenticationManager.signinUser(email: authModel.email, password: authModel.password)
        }).disposed(by: disposeBag)
    }
    
    private func observeUserState() {
        authenticationManager.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success(user: let user):
                if user != nil {
                    self.switchRootViewController()
                }
            case .fail(error: let error):
                print("User creation failed: \(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
    }
}
