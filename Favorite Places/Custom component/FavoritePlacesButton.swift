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
            heightAnchor.constraint(equalToConstant: 60).isActive = true
        case .filled:
            backgroundColor = .customLightBlue
            setTitleColor(.white, for: .normal)
            heightAnchor.constraint(equalToConstant: 60).isActive = true
        case .squareWithImage:
            backgroundColor = .white
            widthAnchor.constraint(equalToConstant: 80).isActive = true
            heightAnchor.constraint(equalToConstant: 80).isActive = true
            contentVerticalAlignment = .fill
            contentHorizontalAlignment = .fill
            imageView?.contentMode = .scaleAspectFit
            imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            tintColor = .customLightBlue
            addShadow()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
