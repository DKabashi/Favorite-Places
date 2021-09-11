//
//  FavoritePlacesTextField.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

class FavoritePlacesTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .customTextFieldBlue
        layer.cornerRadius = .defaultCornerRadius
        font = .systemFont(ofSize: 28)
        let paddingRect = CGRect(x: 0, y: 0, width: 20, height: 30)
        leftView = UIView(frame: paddingRect)
        leftViewMode = .always
        rightView = UIView(frame: paddingRect)
        rightViewMode = .always
        autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
