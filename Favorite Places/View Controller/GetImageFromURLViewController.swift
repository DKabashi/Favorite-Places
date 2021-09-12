//
//  GetImageFromURLViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit
import RxCocoa
import RxSwift

class GetImageFromURLViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = FavoritePlacesLabel(type: .bold)
    private let urlTextField = FavoritePlacesTextField()
    private let getImageButton = FavoritePlacesButton(style: .filled)
    private let closeButton  = FavoritePlacesButton(style: .outline)
    private let disposeBag = DisposeBag()
    private let downloadImageManager = DonwloadImageManager()
    
    let imageFromURL = PublishRelay<UIImage?>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContainerView()
        setupTitleLabel()
        setupButtons()
        setupURLTextField()
        observeDownloadImageManagerState()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    private func setupContainerView() {
        view.add(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -.padding).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 330).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 270).isActive = true
    }
    
    private func setupTitleLabel() {
        view.add(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.text = "Enter image URL"
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
 
    private func setupButtons() {
        getImageButton.setTitle("Get image", for: .normal)
        observeGetImageButtonTap()
        closeButton.setTitle("Cancel", for: .normal)
        observeCloseButtonTap()
        
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.spacing = 10
        stackview.axis = .horizontal
        view.add(stackview)
        stackview.addArrangedSubview(getImageButton)
        stackview.addArrangedSubview(closeButton)
        stackview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.padding).isActive = true
        stackview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        stackview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func observeGetImageButtonTap() {
        getImageButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.downloadImage()
        }).disposed(by: disposeBag)
    }
    
  
    private func observeCloseButtonTap() {
        closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupURLTextField() {
        view.add(urlTextField)
        urlTextField.returnKeyType = .search
        urlTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        urlTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding).isActive = true
        urlTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding).isActive = true
        urlTextField.becomeFirstResponder()
        observeURLTextFieldEditing()
    }
    
    private func observeURLTextFieldEditing() {
        urlTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.downloadImage()
        }).disposed(by: disposeBag)
    }
    
    private func downloadImage() {
        if let stringURL = urlTextField.text, !stringURL.isEmpty {
            downloadImageManager.downloadImage(from: stringURL)
        } else {
            getImageButton.shakeAnimation()
        }
    }
    
    
    private func observeDownloadImageManagerState() {
        downloadImageManager.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .downloading:
                self.view.activityStartAnimating()
            case .error:
                self.view.activityStopAnimating()
                self.imageFromURL.accept(nil)
                self.dismiss(animated: true)
            case .success(image: let image):
                self.view.activityStopAnimating()
                self.imageFromURL.accept(image)
                self.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

