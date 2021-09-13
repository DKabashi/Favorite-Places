//
//  FavoritePlacesCollectionView.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit

class FavoritePlacesCollectionView: UICollectionView {
    init(parentView: UIView) {
        let collectionViewLayout = UICollectionView.createTwoColumnFlowLayout(in: parentView)
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        backgroundColor = .systemBackground
        register(FavoritePlaceCollectionViewCell.self, forCellWithReuseIdentifier: "FavoritePlaceCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
