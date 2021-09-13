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
    private let backButton = BackButton()
    private let deleteButton = UIButton()
    private let changeLocationButton = FavoritePlacesButton(style: .outline)
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
    private let persistanceManager = PersistenceManager()
    private let favoritePlaceNewCoordinate = PublishRelay<Coordinate>()
    
    var favoritePlace: FavoritePlace?
    var isEditingMode: Bool = false
    let additionSucceededWithFavoritePlace = PublishRelay<FavoritePlace>()
    let favoritePlaceItemChanged = PublishRelay<Bool>()
    var latitude: Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
        setupUploadImageView()
        if isEditingMode { setupForEditingFavoritePlaceMode() }
        setupUploadImagePlaceHolderLabel()
        setupLocationNameLabel()
        setupLocationNameTextField()
        setupUploadLabel()
        setupUploadButtonsStackView()
        setupAddFavoritePlaceButton()
        observeImageFromURL()
        observePersistanceStatus()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.observeTap().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func setupBackButton() {
        view.add(backButton)
        backButton.configure(parentView: view)
        observeBackButtonTap()
    }
    
    private func setupUploadImageView() {
        view.add(previewUploadImageView)
        previewUploadImageView.contentMode = .scaleAspectFill
        previewUploadImageView.layer.cornerRadius = 10
        previewUploadImageView.layer.borderColor = UIColor.lightGray.cgColor
        previewUploadImageView.layer.borderWidth = 2
        previewUploadImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.isIphone8PlusSizeOrLower ? .padding : .padding * 2).isActive = true
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
        uploadImagePlaceHolderLabel.widthAnchor.constraint(equalTo: previewUploadImageView.widthAnchor, multiplier: 0.6).isActive = true
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
        locationNameLabel.topAnchor.constraint(equalTo: isEditingMode ? changeLocationButton.bottomAnchor : previewUploadImageView.bottomAnchor, constant: UIScreen.isIphone8PlusSizeOrLower ? .padding : .padding * (isEditingMode ? 2 : 3)).isActive = true
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
        uploadLabel.topAnchor.constraint(equalTo: locationNameTextField.bottomAnchor, constant: UIScreen.isIphone8PlusSizeOrLower ? .padding : .padding * 3).isActive = true
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
        
        if UIScreen.isIphone8Size {
            uploadFromGalleryButton.buttonTitleLabel.font = .systemFont(ofSize: 15)
        }
        
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
        addFavoritePlaceButton.setTitle(isEditingMode ? "Finish editing" : "Add favorite place", for: .normal)
        addFavoritePlaceButton.topAnchor.constraint(equalTo: uploadButtonsStackView.bottomAnchor, constant: UIScreen.isIphone8PlusSizeOrLower ? .padding : .padding * 3).isActive = true
        addFavoritePlaceButton.leadingAnchor.constraint(equalTo: uploadButtonsStackView.leadingAnchor).isActive = true
        addFavoritePlaceButton.trailingAnchor.constraint(equalTo: uploadButtonsStackView.trailingAnchor).isActive = true
        addFavoritePlaceButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        observeAddFavoritePlaceButtonTap()
    }
    
    private func observeAddFavoritePlaceButtonTap() {
        addFavoritePlaceButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isEditingMode ? self.editFavoritePlace() : self.addFavoritePlace()
        }).disposed(by: disposeBag)
    }
    
    private func addFavoritePlace() {
        if let image = previewUploadImageView.image?.pngData() {
            let favoritePlace = FavoritePlace(title: locationNameTextField.text, latitude: latitude, longitude: longitude, imageData: image)
            self.favoritePlace = favoritePlace
            persistanceManager.updateWith(favorite: favoritePlace, actionType: .add)
        } else {
            presentAlert(title: "Add favorite place failed", message: "You need to upload an image for this favorite place.")
        }
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
    
    private func observePersistanceStatus() {
        persistanceManager.failedToPersistWithError.subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            switch error {
            case .alreadyInFavorites:
                self.presentAlert(title: "This place already exists", message: "Please add another place to favorites.")
            default:
                self.presentAlert(title: "Something went wrong", message: "The process of adding this place to favorites failed. Please try again.")
            }
        }).disposed(by: disposeBag)
        
        persistanceManager.persistanceSucceded.subscribe(onNext: {[weak self] actionType in
            guard let self = self else { return }
            switch actionType {
            case .add:
                self.additionSucceededWithFavoritePlace.accept(self.favoritePlace!)
                self.dismiss(animated: true)
            case .remove:
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                    self.dismiss(animated: true)
                }
                self.favoritePlaceItemChanged.accept(true)
            case .edit:
                self.dismiss(animated: true)
                self.favoritePlaceItemChanged.accept(true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupForEditingFavoritePlaceMode() {
        guard let favoritePlace = favoritePlace else {
            return
        }
        latitude = favoritePlace.latitude
        longitude = favoritePlace.longitude
        previewUploadImageView.image = UIImage(data: favoritePlace.imageData)
        locationNameTextField.text = favoritePlace.title
        setupDeleteButton()
        setupChangeLocationButton()
        observeFavoritePlaceNewCoordinate()
    }
    
    private func setupDeleteButton() {
        view.add(deleteButton)

        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor).isActive = true
        observeDeleteButton()
    }
    
    private func observeDeleteButton() {
        deleteButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self, let favoritePlace = self.favoritePlace else { return }
            self.presentAlertWithTwoOptions(title: "Delete favorite place", message: "Are you sure you want to delete this favorite place?", buttonTitle: "Delete", alternativeButtonTitle: "Cancel", buttonCallback: {
                self.persistanceManager.updateWith(favorite: favoritePlace, actionType: .remove)
            }, alternativeButtonCallback: nil)
        }).disposed(by: disposeBag)
    }
    
    private func editFavoritePlace() {
        if let image = previewUploadImageView.image?.pngData() {
            self.favoritePlace?.longitude = longitude
            self.favoritePlace?.imageData = image
            self.favoritePlace?.latitude = latitude
            self.favoritePlace?.title = locationNameTextField.text
            persistanceManager.updateWith(favorite: self.favoritePlace!, actionType: .edit)
        } else {
            presentAlert(title: "Edit favorite place failed", message: "You need to upload an image for this favorite place.")
        }
    }
    
    private func setupChangeLocationButton() {
        view.add(changeLocationButton)
        changeLocationButton.setTitle("Edit location", for: .normal)
        changeLocationButton.titleLabel?.font = .systemFont(ofSize: 20)
        changeLocationButton.topAnchor.constraint(equalTo: previewUploadImageView.bottomAnchor, constant: UIScreen.isIphone8PlusSizeOrLower ? .padding : .padding * 2).isActive = true
        changeLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        changeLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        changeLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        observeChangeLocationButton()
    }
    
    private func observeChangeLocationButton() {
        changeLocationButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self, let favoritePlace = self.favoritePlace else { return }
            let editMapVC = EditMapLocationViewController(favoritePlace: favoritePlace)
            editMapVC.newFavoritePlaceCoordination.bind(to: self.favoritePlaceNewCoordinate).disposed(by: self.disposeBag)
            self.present(editMapVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func observeFavoritePlaceNewCoordinate() {
        favoritePlaceNewCoordinate.subscribe(onNext: {[weak self] coordinate in
            guard let self = self else { return }
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }).disposed(by: disposeBag)
    }
}


extension AddFavoritePlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            presentAlert(title: "Failed to get images", message: "No image found. Please try again.")
            return
        }

        previewUploadImageView.image = image
    }
}
