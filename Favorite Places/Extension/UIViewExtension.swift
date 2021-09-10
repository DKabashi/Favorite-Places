//
//  UIViewExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

extension UIView {
    func add(_ childView: UIView) {
        addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
    }
}
