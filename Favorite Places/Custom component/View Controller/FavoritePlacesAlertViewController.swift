//
//  FavoritePlacesAlertViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import UIKit
import RxCocoa
import RxSwift

class FavoritePlacesAlertViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = FavoritePlacesLabel(type: .bold)
    private let messageLabel = FavoritePlacesLabel(type: .description)
    private let actionButton = FavoritePlacesButton(style: .filled)
    private let alternativeActionButton  = FavoritePlacesButton(style: .outline)
    private let disposeBag = DisposeBag()
    
    private var hasTwoButtons: Bool {
        return alternativeButtonTitle != nil
    }
    
    var alertTitle: String
    var message: String
    var buttonTitle: String
    var buttonCallback: (() -> ())?
    var alternativeButtonTitle: String?
    var alternativeButtonCallback:(() -> ())?

    init(title: String, message: String, buttonTitle: String, alternativeButtonTitle: String? = nil, buttonCallback: (() -> ())? = nil, alternativeButtonCallback: (() -> ())? = nil) {
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.alternativeButtonTitle = alternativeButtonTitle
        self.buttonCallback = buttonCallback
        self.alternativeButtonCallback = alternativeButtonCallback
        super.init(nibName: nil, bundle: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContainerView()
        setupTitleLabel()
        hasTwoButtons ? setupActionButtonWithAlternativeButton() : setupActionButton()
        setupMessageLabel()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }

    private func setupContainerView() {
        view.add(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 230).isActive = true
    }
    
    private func setupTitleLabel() {
        view.add(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.text = alertTitle
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
 
    private func setupActionButton() {
        view.add(actionButton)
        actionButton.setTitle(buttonTitle, for: .normal)
        observeActionButtonTap()
        actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.padding).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func setupActionButtonWithAlternativeButton() {
        actionButton.setTitle(buttonTitle, for: .normal)
        observeActionButtonTap()
        alternativeActionButton.setTitle(alternativeButtonTitle, for: .normal)
        observeAlternativeActionButtonTap()
        
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.spacing = 10
        stackview.axis = .horizontal
        view.add(stackview)
        stackview.addArrangedSubview(actionButton)
        stackview.addArrangedSubview(alternativeActionButton)
        stackview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.padding).isActive = true
        stackview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        stackview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    private func observeActionButtonTap() {
        actionButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let safeCallback = self.buttonCallback { safeCallback() }
            self.dismissVC()
        }).disposed(by: disposeBag)
    }
    
    private func observeAlternativeActionButtonTap() {
        alternativeActionButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let safeCallback = self.alternativeButtonCallback { safeCallback() }
            self.dismissVC()
        }).disposed(by: disposeBag)
    }
    
    private func setupMessageLabel() {
        view.add(messageLabel)
        messageLabel.text = message
        messageLabel.numberOfLines  = 4
        messageLabel.font = .systemFont(ofSize: 25)
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12).isActive = true
    }

    private func dismissVC() {
        dismiss(animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
