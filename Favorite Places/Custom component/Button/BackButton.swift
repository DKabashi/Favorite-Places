//
//  BackButton.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit

class BackButton: UIButton {
    init() {
        super.init(frame: .zero)
        setImage(.back, for: .normal)
        tintColor = .customLightBlue
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
    }
    
    func configure(parentView: UIView) {
        topAnchor.constraint(equalTo: parentView.topAnchor, constant: .padding).isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: .padding).isActive = true
        widthAnchor.constraint(equalToConstant: 33).isActive = true
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
