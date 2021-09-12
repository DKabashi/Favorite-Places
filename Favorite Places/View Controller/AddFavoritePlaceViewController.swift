//
//  AddFavoritePlaceViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import UIKit
import RxCocoa
import RxSwift

class AddFavoritePlaceViewController: UIViewController {
    private let previewUploadImageView = UIImageView()
    private let uploadImagePlaceHolderLabel = FavoritePlacesLabel(type: .description)
    private let backButton = UIButton()
    private let locationNameLabel = FavoritePlacesLabel(type: .description)
    private let locationNameTextField = FavoritePlacesTextField()
    private let uploadLabel = FavoritePlacesLabel(type: .description)
    private let uploadButtonsStackView = UIStackView()
    private let uploadFromGalleryButton = VerticalButtonStack(image: .photoLibrary, text: "Photo Library")
    private let uploadFromCameraButton = VerticalButtonStack(image: .camera, text: "Camera")
    private let uploadFromURLButton = VerticalButtonStack(image: .globe, text: "Image URL")
    private let addFavoritePlaceButton = FavoritePlacesButton(style: .filled)
    private let imageFromURL = PublishRelay<UIImage?>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
        setupUploadImageView()
        setupUploadImagePlaceHolderLabel()
        setupLocationNameLabel()
        setupLocationNameTextField()
        setupUploadLabel()
        setupUploadButtonsStackView()
        setupAddFavoritePlaceButton()
        observeImageFromURL()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.observeTap().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func setupBackButton() {
        view.add(backButton)
        backButton.setImage(.back, for: .normal)
        backButton.tintColor = .customLightBlue
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.contentHorizontalAlignment = .fill
        backButton.contentVerticalAlignment = .fill
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .padding).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        observeBackButtonTap()
    }
    
    private func setupUploadImageView() {
        view.add(previewUploadImageView)
        previewUploadImageView.contentMode = .scaleAspectFill
        previewUploadImageView.layer.cornerRadius = 10
        previewUploadImageView.layer.borderColor = UIColor.lightGray.cgColor
        previewUploadImageView.layer.borderWidth = 2
        previewUploadImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: .padding * 2).isActive = true
        previewUploadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        previewUploadImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        previewUploadImageView.heightAnchor.constraint(equalTo: previewUploadImageView.widthAnchor).isActive = true
    }
    
    private func setupUploadImagePlaceHolderLabel() {
        view.add(uploadImagePlaceHolderLabel)
        uploadImagePlaceHolderLabel.layer.zPosition = -1
        uploadImagePlaceHolderLabel.text = "Upload an image"
        uploadImagePlaceHolderLabel.textAlignment = .center
        previewUploadImageView.clipsToBounds = true
        uploadImagePlaceHolderLabel.centerXAnchor.constraint(equalTo: previewUploadImageView.centerXAnchor).isActive = true
        uploadImagePlaceHolderLabel.centerYAnchor.constraint(equalTo: previewUploadImageView.centerYAnchor).isActive = true
        uploadImagePlaceHolderLabel.widthAnchor.constraint(equalTo: previewUploadImageView.widthAnchor, multiplier: 0.5).isActive = true
        uploadImagePlaceHolderLabel.heightAnchor.constraint(equalTo: uploadImagePlaceHolderLabel.widthAnchor).isActive = true
    }
    
    private func observeBackButtonTap() {
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupLocationNameLabel() {
        view.add(locationNameLabel)
        locationNameLabel.text = "Name of location (Optional):"
        locationNameLabel.topAnchor.constraint(equalTo: previewUploadImageView.bottomAnchor, constant: .padding * 3).isActive = true
        locationNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        locationNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupLocationNameTextField() {
        view.add(locationNameTextField)
        locationNameTextField.returnKeyType = .done
        locationNameTextField.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: .padding).isActive = true
        locationNameTextField.leadingAnchor.constraint(equalTo: locationNameLabel.leadingAnchor).isActive = true
        locationNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        observeLocationNameTextFieldEditing()
    }
    
    private func observeLocationNameTextFieldEditing() {
        locationNameTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {
            self.locationNameTextField.resignFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    private func setupUploadLabel() {
        view.add(uploadLabel)
        uploadLabel.text = "Upload image from:"
        uploadLabel.topAnchor.constraint(equalTo: locationNameTextField.bottomAnchor, constant: .padding * 3).isActive = true
        uploadLabel.leadingAnchor.constraint(equalTo: locationNameTextField.leadingAnchor).isActive = true
        uploadLabel.trailingAnchor.constraint(equalTo: locationNameTextField.trailingAnchor).isActive = true
        uploadLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupUploadButtonsStackView() {
        view.add(uploadButtonsStackView)
        uploadButtonsStackView.addArrangedSubview(uploadFromCameraButton)
        uploadButtonsStackView.addArrangedSubview(uploadFromGalleryButton)
        uploadButtonsStackView.addArrangedSubview(uploadFromURLButton)
        uploadButtonsStackView.axis = .horizontal
        uploadButtonsStackView.distribution = .fillEqually
        uploadButtonsStackView.spacing = 15
        
        uploadButtonsStackView.topAnchor.constraint(equalTo: uploadLabel.bottomAnchor, constant: .padding).isActive = true
        uploadButtonsStackView.leadingAnchor.constraint(equalTo: uploadLabel.leadingAnchor).isActive = true
        uploadButtonsStackView.trailingAnchor.constraint(equalTo: uploadLabel.trailingAnchor).isActive = true
        uploadButtonsStackView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        observeCameraButtonTap()
        observePhotoLibraryButtonTap()
        observeUploadFromURLButtonTap()
    }
    
    private func observeCameraButtonTap() {
        uploadFromCameraButton.observeTap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.getImage(using: .camera)
            }
        }).disposed(by: disposeBag)
    }
    
    private func observePhotoLibraryButtonTap() {
        uploadFromGalleryButton.observeTap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.getImage(using: .photoLibrary)
        }).disposed(by: disposeBag)
    }
    
    private func observeUploadFromURLButtonTap() {
        uploadFromURLButton.observeTap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let getImageFromURLVC = GetImageFromURLViewController()
            getImageFromURLVC.modalPresentationStyle = .overFullScreen
            getImageFromURLVC.modalTransitionStyle = .crossDissolve
            getImageFromURLVC.imageFromURL.bind(to: self.imageFromURL).disposed(by: self.disposeBag)
            self.present(getImageFromURLVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    private func getImage(using sourceType: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func setupAddFavoritePlaceButton() {
        view.add(addFavoritePlaceButton)
        addFavoritePlaceButton.setTitle("Add favorite place", for: .normal)
        addFavoritePlaceButton.topAnchor.constraint(equalTo: uploadButtonsStackView.bottomAnchor, constant: .padding * 3).isActive = true
        addFavoritePlaceButton.leadingAnchor.constraint(equalTo: uploadButtonsStackView.leadingAnchor).isActive = true
        addFavoritePlaceButton.trailingAnchor.constraint(equalTo: uploadButtonsStackView.trailingAnchor).isActive = true
        addFavoritePlaceButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func observeImageFromURL() {
        imageFromURL.subscribe(onNext: { [weak self] image in
            guard let self = self else { return }
            guard let image = image else {
                self.presentAlert(title: "Image download failed", message: "Something went wrong. Please try again with a different URL.")
                return
            }
            self.previewUploadImageView.image = image
        }).disposed(by: disposeBag)
    }
}


extension AddFavoritePlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        previewUploadImageView.image = image
    }
}
