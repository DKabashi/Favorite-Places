//
//  FavoritePlaceCollectionViewCell.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit

class FavoritePlaceCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = FavoritePlacesLabel(type: .description)
    
    var favoritePlace: FavoritePlace?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func configure(with favoritePlace: FavoritePlace) {
        self.favoritePlace = favoritePlace
        imageView.image = UIImage(data: favoritePlace.imageData)
        titleLabel.text = favoritePlace.title
    }
    
    private func setup() {
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupImageView() {
        add(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 2
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        imageView.clipsToBounds = true
    }
    
    private func setupTitleLabel() {
        add(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
