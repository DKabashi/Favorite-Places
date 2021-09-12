//
//  VerticalButtonStack.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import UIKit

class VerticalButtonStack: UIStackView {
    let buttonImage = UIImageView()
    let buttonTitleLabel = UILabel()
    
    init(image: UIImage, text: String) {
        super.init(frame: .zero)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.customLightBlue.cgColor
        tintColor = .customLightBlue
        buttonImage.image = image
        buttonTitleLabel.text = text
        buttonImage.contentMode = .scaleAspectFit
        buttonTitleLabel.textAlignment = .center
        addArrangedSubview(UIView())
        addArrangedSubview(buttonImage)
        addArrangedSubview(buttonTitleLabel)
        addArrangedSubview(UIView())
        axis = .vertical
        distribution = .fillEqually
        contentMode = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
