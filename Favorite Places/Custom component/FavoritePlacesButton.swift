//
//  FavoritePlacesButton.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

class FavoritePlacesButton: UIButton {
    
    init(style: ButtonStyle) {
        super.init(frame: .zero)
        layer.cornerRadius = .defaultCornerRadius
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        switch style {
        case .outline:
            backgroundColor = .white
            layer.borderWidth = 2
            layer.borderColor = UIColor.customLightBlue.cgColor
            setTitleColor(.customLightBlue, for: .normal)
        case .filled:
            backgroundColor = .customLightBlue
            setTitleColor(.white, for: .normal)
        case .squareWithImage:
            backgroundColor = .white
        }
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
