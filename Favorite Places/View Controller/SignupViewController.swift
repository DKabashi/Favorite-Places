//
//  SignupViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit
import RxCocoa
import RxSwift

class SignupViewController: UIViewController {
    
    private let authenticationView = AuthenticationView(isLogin: false)
    private let authenticationManager = AuthenticationManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAuthenticationView()
        observeSignupRequest()
        observeUserState()
        observeAlternativeAuthRequest()
        observeInvalidCredentials()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupAuthenticationView() {
        view.add(authenticationView)
        authenticationView.pinToEdges(of: view, topPadding: .padding * 4, bottomPadding: .padding * 3)
    }
    
    private func observeSignupRequest() {
        authenticationView.authenticationRequestWithModel.subscribe(onNext: { [weak self] authModel in
            guard let self = self else { return }
            self.authenticationManager.createUser(email: authModel.email, password: authModel.password)
        }).disposed(by: disposeBag)
    }
    
    private func observeUserState() {
        authenticationManager.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            self.authenticationView.activityStopAnimating()
            switch state {
            case .success(user: let user):
                if user != nil {
                    self.switchRootViewController()
                }
            case .fail(error: let error):
                self.presentAlert(title: "Failed to create account", message: error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    private func observeAlternativeAuthRequest() {
        authenticationView.alternativeAuthenticationRequest.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
            self.removeFromParent()
        }).disposed(by: disposeBag)
    }
    
    private func observeInvalidCredentials() {
        authenticationView.invalidCredentialsWithMessage.subscribe(onNext: {[weak self] message in
            guard let self = self else { return }
            self.presentAlert(title: "Invalid credentials", message: message)
        }).disposed(by: disposeBag)
    }
}
