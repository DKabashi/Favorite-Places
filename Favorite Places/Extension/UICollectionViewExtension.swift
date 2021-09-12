//
//  UICollectionViewExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit

extension UICollectionView {
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (.padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = (availableWidth / 2) - .padding
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: .padding, left: .padding, bottom: .padding, right: .padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
