//
//  LandingViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

class LandingViewController: UIViewController {
    
    let mapImageView = UIImageView(image: .map)
    let titleLabel = FavoritePlacesLabel(type: .title)
    let descriptionLabel = FavoritePlacesLabel(type: .description)
    let signupButton = FavoritePlacesButton(style: .filled)
    let loginButton = FavoritePlacesButton(style: .outline)
    let padding = CGFloat(25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMapImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupSignupButton()
        setupLoginButton()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupMapImageView() {
        view.add(mapImageView)
        mapImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        mapImageView.contentMode = .center
    }
    
    private func setupTitleLabel() {
        view.add(titleLabel)
        titleLabel.text = "Favorite Places"
        titleLabel.topAnchor.constraint(equalTo: mapImageView.bottomAnchor, constant: padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupDescriptionLabel() {
        view.add(descriptionLabel)
        descriptionLabel.text = "Navigate an intuitive map and save your favorite places in your pocket"
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupSignupButton() {
        view.add(signupButton)
        signupButton.setTitle("Sign up", for: .normal)
        signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupLoginButton() {
        view.add(loginButton)
        loginButton.setTitle("Log in", for: .normal)
        loginButton.bottomAnchor.constraint(equalTo: signupButton.bottomAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalTo: signupButton.heightAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: signupButton.widthAnchor).isActive = true
    }
}
