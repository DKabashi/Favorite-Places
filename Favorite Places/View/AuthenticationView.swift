//
//  AuthenticationView.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit
import RxCocoa
import RxSwift

class AuthenticationView: UIView {
    private let titleLabel = FavoritePlacesLabel(type: .title)
    private let emailLabel = FavoritePlacesLabel(type: .description)
    private let emailTextField = FavoritePlacesTextField()
    private let passwordLabel = FavoritePlacesLabel(type: .description)
    private let passwordTextField = FavoritePlacesTextField()
    private let authenticateButton = FavoritePlacesButton(style: .filled)
    private let alternativeAuthenticationLabel = FavoritePlacesLabel(type: .description)
    private let alternativeAuthenticationButton = UIButton()
    private let disposeBag = DisposeBag()
    
    let authenticationRequestWithModel = PublishRelay<AuthenticationModel>()
    var isLogin: Bool
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
        super.init(frame: .zero)
        setupTitleLabel()
        setupEmailLabel()
        setupEmailTextField()
        setupPasswordLabel()
        setupPasswordTextField()
        setupAuthenticateButton()
        setupAlternativeAuthenticationText()
    }
    
    private func setupTitleLabel() {
        add(titleLabel)
        titleLabel.text = isLogin ? "Welcome\nBack" : "Create\nAccount"
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.padding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupEmailLabel() {
        add(emailLabel)
        emailLabel.text = isLogin ? "Email:" : "Your email:"
        emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .padding * 3).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func setupEmailTextField() {
        add(emailTextField)
        observeEmailTextFieldEditing()
        emailTextField.returnKeyType = .continue
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: .padding).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func observeEmailTextFieldEditing() {
        emailTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {
            self.passwordTextField.becomeFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    private func setupPasswordLabel() {
        add(passwordLabel)
        observePasswordTextFieldEditing()
        passwordTextField.returnKeyType = .done
        passwordLabel.text = isLogin ? "Password:" : "Your password:"
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .padding * 2).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func observePasswordTextFieldEditing() {
        passwordTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {
            self.passwordTextField.resignFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    private func setupPasswordTextField() {
        add(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: .padding).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupAuthenticateButton() {
        add(authenticateButton)
        authenticateButton.setTitle(isLogin ? "Sign In" : "Sign Up", for: .normal)
        authenticateButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .padding * 4).isActive = true
        authenticateButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        authenticateButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        observeAuthenticationButtonTap()
    }
    
    private func observeAuthenticationButtonTap() {
        authenticateButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self, let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            if email.contains("@") && password.count > 4 {
                let authModel = AuthenticationModel(email: email, password: password)
                self.authenticationRequestWithModel.accept(authModel)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupAlternativeAuthenticationText() {
        add(alternativeAuthenticationLabel)
        add(alternativeAuthenticationButton)
        
        alternativeAuthenticationLabel.font = .systemFont(ofSize: 20)
        alternativeAuthenticationLabel.text = isLogin ? "Don't have an account?" : "Already have an account?"
        alternativeAuthenticationLabel.topAnchor.constraint(equalTo: authenticateButton.bottomAnchor, constant: .padding).isActive = true
        alternativeAuthenticationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        alternativeAuthenticationButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        alternativeAuthenticationButton.setTitle(isLogin ? "Sign up" : "Log in", for: .normal)
        alternativeAuthenticationButton.setTitleColor(.customLightBlue, for: .normal)
        alternativeAuthenticationButton.leadingAnchor.constraint(equalTo: alternativeAuthenticationLabel.trailingAnchor).isActive = true
        alternativeAuthenticationButton.heightAnchor.constraint(equalTo: alternativeAuthenticationLabel.heightAnchor).isActive = true
        alternativeAuthenticationButton.topAnchor.constraint(equalTo: alternativeAuthenticationLabel.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
