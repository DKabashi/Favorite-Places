//
//  AuthenticationView.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

class AuthenticationView: UIView {
    let titleLabel = FavoritePlacesLabel(type: .title)
    let emailLabel = FavoritePlacesLabel(type: .description)
    let emailTextField = FavoritePlacesTextField()
    let passwordLabel = FavoritePlacesLabel(type: .description)
    let passwordTextField = FavoritePlacesTextField()
    let authenticateButton = FavoritePlacesButton(style: .filled)
    let alternativeAuthenticationLabel = FavoritePlacesLabel(type: .description)
    let alternativeAuthenticationButton = UIButton()
    
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
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: .padding).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupPasswordLabel() {
        add(passwordLabel)
        passwordLabel.text = isLogin ? "Password:" : "Your password:"
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .padding * 2).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func setupPasswordTextField() {
        add(passwordTextField)
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
