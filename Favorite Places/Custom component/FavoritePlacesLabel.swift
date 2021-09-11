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
        minimumScaleFactor = 0.7
        switch type {
        case .title:
            fontSize = 50
            fontWeight = .bold
            textColor = .darkGray
            numberOfLines = 2
            minimumScaleFactor = 0.9
        case .description:
            fontSize = 30
            numberOfLines = 4
            textColor = .gray
        case .bold:
            fontSize = 30
            fontWeight = .bold
            textColor = .darkGray
        }
        adjustsFontSizeToFitWidth = true
        font = .systemFont(ofSize: fontSize, weight: fontWeight)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
