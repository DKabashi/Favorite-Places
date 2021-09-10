//
//  FavoritePlacesLabel.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

class FavoritePlacesLabel: UILabel {
    
    init(type: LabelType) {
        super.init(frame: .zero)
        var fontSize: CGFloat = 17
        var fontWeight = UIFont.Weight.regular
        switch type {
        case .title:
            fontSize = 40
            fontWeight = .bold
            textColor = .darkGray
        case .description:
            fontSize = 30
            numberOfLines = 4
            textColor = .gray
        case .bold:
            fontWeight = .bold
            textColor = .darkGray
        }
        font = .systemFont(ofSize: fontSize, weight: fontWeight)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
