//
//  FavoritesListViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit
import RxCocoa
import RxSwift

class FavoritesListViewController: UIViewController {
    private let backButton = BackButton()
    private let titleLabel = FavoritePlacesLabel(type: .title)
    private let descriptionLabel = FavoritePlacesLabel(type: .description)
    private let emptyDataLabel = FavoritePlacesLabel(type: .description)
    private var favoritesListCollectionView: FavoritePlacesCollectionView!
    private let disposeBag = DisposeBag()
    
    private let persistanceManager = PersistenceManager()
    private var favoritePlaces = BehaviorRelay<[FavoritePlace]>(value: [])
    
    let selectedFavoritePlace = PublishRelay<FavoritePlace>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
        setupTitleLabel()
        setupDescriptionLabel()
        setupEmptyDataLabel()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavoritesDataSource()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func updateFavoritesDataSource() {
        persistanceManager.retrieveFavorites { result in
            switch result {
            case .success(let favoritePlaces):
                let userSpecificResults = favoritePlaces.filter {
                    $0.user.email == AuthenticationManager.currentUser?.email ?? ""
                }
                self.favoritePlaces.accept(userSpecificResults)
            default:
                self.favoritePlaces.accept([])
                return
            }
        }
    }
    
    private func setupBackButton() {
        view.add(backButton)
        backButton.configure(parentView: view)
        observeBackButtonTap()
    }
    
    private func setupTitleLabel() {
        view.add(titleLabel)
        titleLabel.text = "List of your favorite places"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setupDescriptionLabel() {
        view.add(descriptionLabel)
        descriptionLabel.text = "🔹 Tap an item to go to that location in map.\n\n🔹 Tap and hold an item to edit it."
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .regular)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .padding * 2).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupEmptyDataLabel() {
        view.add(emptyDataLabel)
        emptyDataLabel.text = "You don't have any ⭐️ places yet. Tap and hold the 🗺 to add one."
        emptyDataLabel.numberOfLines = 3
        emptyDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding).isActive = true
        emptyDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding).isActive = true
        emptyDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyDataLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupCollectionView() {
        favoritesListCollectionView = FavoritePlacesCollectionView(parentView: view)
        view.add(favoritesListCollectionView)
        favoritesListCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .padding).isActive = true
        favoritesListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        favoritesListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        favoritesListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        setupCollectionViewCellsWithDataSource()
        observeCollectionViewCells()
    }
    
    private func setupCollectionViewCellsWithDataSource() {
        favoritePlaces.bind(to: favoritesListCollectionView.rx
                                .items(cellIdentifier: "FavoritePlaceCell", cellType: FavoritePlaceCollectionViewCell.self)) {[weak self] index, favoritePlace, cell in
            guard let _ = self else { return }
            cell.configure(with: favoritePlace)
        }.disposed(by: disposeBag)
    }
    
    private func observeCollectionViewCells() {
        favoritesListCollectionView.rx.modelSelected(FavoritePlace.self).subscribe(onNext: { [weak self] favoritePlace in
            guard let self = self else { return }
            self.selectedFavoritePlace.accept(favoritePlace)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        view.observeLongPress().subscribe(onNext: {[weak self] longPressGesture in
            guard let self = self else { return }
            guard longPressGesture.state == .ended else {
                return
            }
            let gestureLocation = longPressGesture.location(in: self.favoritesListCollectionView)
            if let indexPath = self.favoritesListCollectionView.indexPathForItem(at: gestureLocation), let favoritePlaceCell = self.favoritesListCollectionView.cellForItem(at: indexPath) as? FavoritePlaceCollectionViewCell {
                print(favoritePlaceCell.favoritePlace)
            }
        }).disposed(by: disposeBag)
    }
    
    private func observeBackButtonTap() {
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}
